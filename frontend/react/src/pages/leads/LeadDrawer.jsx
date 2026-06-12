import { useState, useEffect, useRef } from 'react';
import Drawer from '@/components/atoms/Drawer';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { useToast } from '@/components/atoms/Toasts';
import { StatusBadge, Icon, toneClasses } from './leadActions';

// Fields the Edit form exposes. Add a line here and it is fully wired — input,
// dirty-tracking, discard-guard and save all pick it up automatically. The
// backend PATCH /.rest/leads/{id} accepts arbitrary keys, so the only coupling
// is that the key must match a column the controller knows how to set.
const EDIT_FIELDS = [
    { key: 'contactEmail',   label: 'Contact email',   type: 'email',  hint: 'Entering an email on a stalled lead advances it to Contact Found so outreach can proceed' },
    { key: 'price',          label: 'Listed price',    type: 'number', hint: 'SL price is derived from this — 10% off, rounded to nearest 5' },
    { key: 'agreedFee',      label: 'Agreed fee',      type: 'number', hint: 'If the lead has quoted their own fee, set it here — it overrides the listed price and the derived SL price' },
    { key: 'currency',       label: 'Currency',        type: 'text',   maxLength: 8, placeholder: 'GBP' },
    { key: 'linksPermitted', label: 'Links permitted', type: 'select', options: [{ value: 3, label: '3 links' }, { value: 2, label: '2 links' }], hint: 'How many links this supplier allows per page (2 or 3). Carried onto the Supplier when converting.' },
];

const CCY = { GBP: '£', USD: '$', EUR: '€' };
function money(amt, ccy) {
    if (amt == null || amt === '') return '—';
    return `${CCY[ccy] ?? (ccy ? `${ccy} ` : '')}${amt}`;
}
// Mirrors LeadPricing.suggestedFee on the backend: 10% off, rounded to nearest 5.
function deriveSlPrice(price, ccy) {
    const n = Number(price);
    if (!price || Number.isNaN(n) || n <= 0) return '—';
    return money(Math.round((n * 0.9) / 5) * 5, ccy);
}
// The fee we'll actually use: the lead's agreed (quoted) fee if set, else the derived SL price.
function effectiveFee(agreedFee, price, ccy) {
    if (agreedFee != null && agreedFee !== '') return money(agreedFee, ccy);
    return deriveSlPrice(price, ccy);
}

const numFont = { fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.01em' };

/**
 * Lead detail drawer with a View ⇄ Edit mode-swap.
 *
 *  - View mode  : read-only details + the action list (where you DO things).
 *  - Edit mode  : the field form + Save/Cancel (where you CHANGE things). Actions
 *                 are not rendered, so an immediate action can never fire with
 *                 unsaved edits. Closing/cancelling while dirty prompts to discard.
 */
export default function LeadDrawer({ open, lead, actions, editable = true, onClose, onRunAction, onSaved }) {
    const { addToast: toast } = useToast();
    const [mode, setMode] = useState('view');
    const [draft, setDraft] = useState(null);
    const [pendingDiscard, setPendingDiscard] = useState(false);
    const [saving, setSaving] = useState(false);

    // Retain the last lead so content stays put during the close transition.
    const lastLeadRef = useRef(lead);
    if (lead) lastLeadRef.current = lead;
    const shown = lead ?? lastLeadRef.current;

    // Reset to View whenever a different lead is opened (or the drawer toggles).
    useEffect(() => {
        setMode('view');
        setDraft(null);
        setPendingDiscard(false);
    }, [lead?.id, open]);

    if (!shown) return <Drawer open={open} onClose={onClose} />;

    const editing = mode === 'edit';
    const dirty = editing && draft != null &&
        EDIT_FIELDS.some(f => String(draft[f.key] ?? '') !== String(shown[f.key] ?? ''));

    function requestClose() {
        if (dirty) { setPendingDiscard(true); return; }
        onClose();
    }
    function enterEdit() {
        const d = {};
        EDIT_FIELDS.forEach(f => { d[f.key] = shown[f.key] ?? ''; });
        setDraft(d);
        setMode('edit');
        setPendingDiscard(false);
    }
    function cancelEdit() {
        if (dirty) { setPendingDiscard(true); return; }
        setMode('view');
        setDraft(null);
    }
    function discardChanges() {
        setPendingDiscard(false);
        setMode('view');
        setDraft(null);
    }
    function setField(key, value) {
        setDraft(prev => ({ ...prev, [key]: value }));
    }

    async function save() {
        if (!dirty) return;
        const changes = {};
        EDIT_FIELDS.forEach(f => {
            if (String(draft[f.key] ?? '') !== String(shown[f.key] ?? '')) {
                changes[f.key] = draft[f.key] === '' ? null : draft[f.key];
            }
        });
        setSaving(true);
        try {
            const r = await fetchWithAuth(`/.rest/leads/${shown.id}`, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(changes),
            });
            if (!r.ok) throw new Error(r.status);
            const updated = await r.json();
            toast(`Saved changes for ${updated.domain}`, 'success');
            onSaved(updated);
            setMode('view');
            setDraft(null);
        } catch {
            toast('Failed to save changes', 'error');
        } finally {
            setSaving(false);
        }
    }

    const title = <div className="font-mono text-sm font-semibold text-indigo-600 truncate">{shown.domain}</div>;
    const subtitle = editing
        ? <span className="inline-flex items-center gap-1.5 text-[11px] font-semibold text-indigo-600"><Icon name="edit" className="w-3.5 h-3.5" /> Editing details</span>
        : <StatusBadge status={shown.status} />;

    return (
        <Drawer open={open} onClose={requestClose} title={title} subtitle={subtitle} dismissOnBackdropClick={!dirty}>
            {editing ? renderEdit() : renderView()}
        </Drawer>
    );

    // ── View mode ────────────────────────────────────────────────────────────
    function renderView() {
        const detailRow = (label, value, cls = 'text-slate-700') => (
            <div className="flex justify-between gap-3">
                <span>{label}</span>
                <span className={cls}>{value}</span>
            </div>
        );

        const actionRow = (a) => (
            <button
                key={a.key}
                disabled={a.disabled}
                onClick={() => onRunAction(a)}
                title={a.disabledHint}
                className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-left text-sm border transition-colors disabled:opacity-50 disabled:cursor-not-allowed ${toneClasses(a.tone)}`}
            >
                <span className={`shrink-0 ${a.tone === 'danger' ? 'text-rose-500' : a.tone === 'neutral' ? 'text-slate-400' : ''}`}>
                    <Icon name={a.icon} />
                </span>
                <span className="font-medium flex-1">{a.label}</span>
                {a.disabled && a.disabledHint && <span className="text-[10px] opacity-70">{a.disabledHint}</span>}
            </button>
        );

        const group = (heading, items) => (items && items.length > 0) ? (
            <div className="mb-5">
                <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400 mb-2">{heading}</div>
                <div className="flex flex-col gap-1.5">{items.map(actionRow)}</div>
            </div>
        ) : null;

        return (
            <>
                <div className="rounded-xl border border-slate-200 bg-slate-50 p-3 mb-3 text-xs text-slate-500 space-y-1.5">
                    {detailRow('Listed price', money(shown.price, shown.currency), 'text-slate-700')}
                    {shown.agreedFee
                        ? detailRow('Agreed fee', money(shown.agreedFee, shown.currency), 'font-semibold text-emerald-700')
                        : detailRow('SL price', deriveSlPrice(shown.price, shown.currency), 'font-semibold text-emerald-700')}
                    {detailRow('Links permitted', `${shown.linksPermitted ?? 3} links`)}
                    {detailRow('Contact', shown.contactEmail || '—')}
                    {shown.declineReason && detailRow('Decline reason', shown.declineReason, 'text-rose-500 italic')}
                </div>

                {shown.message && (
                    <div className="rounded-xl border border-amber-200 bg-amber-50 p-3 mb-3">
                        <div className="flex items-center gap-1.5 text-[11px] font-bold uppercase tracking-wider text-amber-700 mb-1.5">
                            <Icon name="mail" className="w-3.5 h-3.5" /> Message from lead
                        </div>
                        <p className="text-sm text-amber-900 whitespace-pre-wrap break-words leading-relaxed">{shown.message}</p>
                    </div>
                )}

                {editable && (
                    <button
                        onClick={enterEdit}
                        className="w-full mb-5 flex items-center justify-center gap-2 px-3 py-2 rounded-lg text-sm font-semibold text-slate-700 border border-slate-200 hover:bg-slate-50 transition-colors"
                    >
                        <Icon name="edit" /> Edit details
                    </button>
                )}

                {actions.waiting && <div className="mb-5 text-sm italic text-slate-400">{actions.waiting}</div>}
                {group('Next step', actions.primary ? [actions.primary] : [])}
                {group('Actions', actions.secondary)}
                {group('Danger zone', actions.danger)}
            </>
        );
    }

    // ── Edit mode ────────────────────────────────────────────────────────────
    function renderEdit() {
        const inputCls = 'w-full border border-slate-200 rounded-lg px-3 py-2 text-sm text-slate-700 placeholder-slate-300 focus:outline-none focus:border-indigo-400 focus:ring-2 focus:ring-indigo-100';
        return (
            <>
                {pendingDiscard && (
                    <div className="mb-4 rounded-lg border border-amber-300 bg-amber-50 p-3">
                        <p className="text-sm text-amber-800 font-medium mb-2">Discard unsaved changes?</p>
                        <div className="flex gap-2">
                            <button onClick={discardChanges} className="text-xs font-semibold px-3 py-1.5 rounded-lg text-white bg-rose-600 hover:bg-rose-700">Discard</button>
                            <button onClick={() => setPendingDiscard(false)} className="text-xs font-semibold px-3 py-1.5 rounded-lg text-slate-600 border border-slate-200 hover:bg-white">Keep editing</button>
                        </div>
                    </div>
                )}

                <div className="rounded-xl border border-indigo-100 bg-indigo-50/40 p-3 mb-5 flex items-center justify-between text-xs">
                    <span className="text-slate-500">{draft?.agreedFee ? 'Agreed fee (overrides SL price)' : 'Derived SL price'}</span>
                    <span className="font-semibold text-emerald-700" style={numFont}>{effectiveFee(draft?.agreedFee, draft?.price, draft?.currency)}</span>
                </div>

                <div className="flex flex-col gap-4 pb-4">
                    {EDIT_FIELDS.map(f => (
                        <label key={f.key} className="flex flex-col gap-1.5">
                            <span className="text-[11px] font-semibold text-slate-500 uppercase tracking-wide">{f.label}</span>
                            {f.type === 'select' ? (
                                <select
                                    value={draft?.[f.key] ?? ''}
                                    onChange={e => setField(f.key, e.target.value)}
                                    className={inputCls}
                                >
                                    {f.options.map(o => (
                                        <option key={o.value} value={o.value}>{o.label}</option>
                                    ))}
                                </select>
                            ) : (
                                <input
                                    type={f.type === 'number' ? 'number' : f.type === 'email' ? 'email' : 'text'}
                                    value={draft?.[f.key] ?? ''}
                                    maxLength={f.maxLength}
                                    placeholder={f.placeholder}
                                    onChange={e => setField(f.key, e.target.value)}
                                    className={inputCls}
                                />
                            )}
                            {f.hint && <span className="text-[11px] text-slate-400">{f.hint}</span>}
                        </label>
                    ))}
                </div>

                <div className="sticky bottom-0 -mx-5 px-5 py-3 bg-white/90 backdrop-blur border-t border-slate-100 flex items-center justify-end gap-2">
                    <button onClick={cancelEdit} className="text-sm px-3 py-1.5 rounded-lg text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-colors">Cancel</button>
                    <button
                        onClick={save}
                        disabled={!dirty || saving}
                        className="text-sm px-4 py-1.5 rounded-lg font-semibold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors border border-indigo-700 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                        {saving ? 'Saving…' : 'Save changes'}
                    </button>
                </div>
            </>
        );
    }
}
