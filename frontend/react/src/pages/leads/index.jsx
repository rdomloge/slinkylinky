import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthProvider';
import Layout from '@/components/layout/Layout';
import Loading from '@/components/Loading';
import Modal from '@/components/atoms/Modal';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { useToast } from '@/components/atoms/Toasts';

// ── Status config ─────────────────────────────────────────────────────────────

const STATUS_CONFIG = {
    NEW:               { label: 'New',              bg: 'bg-slate-100',   text: 'text-slate-600',   dot: '#94a3b8' },
    SEARCHING:         { label: 'Searching',        bg: 'bg-amber-100',   text: 'text-amber-700',   dot: '#f59e0b' },
    BROWSER_QUEUED:    { label: 'Browser Queued',   bg: 'bg-violet-100',  text: 'text-violet-700',  dot: '#7c3aed' },
    CONTACT_FOUND:     { label: 'Contact Found',    bg: 'bg-amber-100',   text: 'text-amber-700',   dot: '#f59e0b' },
    CONTACT_NOT_FOUND: { label: 'Not Found',        bg: 'bg-rose-100',    text: 'text-rose-600',    dot: '#f43f5e' },
    OUTREACH_SENT:     { label: 'Outreach Sent',    bg: 'bg-blue-100',    text: 'text-blue-700',    dot: '#3b82f6' },
    ACCEPTED:          { label: 'Accepted',         bg: 'bg-emerald-100', text: 'text-emerald-700', dot: '#10b981' },
    DECLINED:          { label: 'Declined',         bg: 'bg-red-100',     text: 'text-red-600',     dot: '#ef4444' },
};

const PIPELINE_STEPS = ['NEW', 'BROWSER_QUEUED', 'CONTACT_FOUND', 'OUTREACH_SENT', 'ACCEPTED'];

function StatusBadge({ status }) {
    const cfg = STATUS_CONFIG[status] ?? STATUS_CONFIG.NEW;
    return (
        <span className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-[11px] font-semibold ${cfg.bg} ${cfg.text}`}>
            <span className="w-1.5 h-1.5 rounded-full shrink-0" style={{ background: cfg.dot }} />
            {cfg.label}
        </span>
    );
}

function ActionBtn({ label, onClick, disabled, variant = 'ghost', title }) {
    const variants = {
        ghost:   'text-slate-500 hover:text-slate-800 hover:bg-slate-100',
        primary: 'text-white bg-indigo-600 hover:bg-indigo-700',
        success: 'text-white bg-emerald-600 hover:bg-emerald-700',
        warning: 'text-amber-700 bg-amber-50 border-amber-200 hover:bg-amber-100',
    };
    return (
        <button
            onClick={onClick}
            disabled={disabled}
            title={title}
            className={`text-xs px-2.5 py-1 rounded-md font-medium border border-transparent transition-colors disabled:opacity-40 disabled:cursor-not-allowed ${variants[variant]}`}
        >
            {label}
        </button>
    );
}

// ── Pipeline summary bar ──────────────────────────────────────────────────────

function PipelineBar({ leads }) {
    const counts = leads.reduce((acc, l) => {
        acc[l.status] = (acc[l.status] || 0) + 1;
        return acc;
    }, {});

    return (
        <div className="mx-6 mb-5 rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
            <div className="grid grid-cols-5 divide-x divide-slate-100">
                {PIPELINE_STEPS.map((status, i) => {
                    const cfg = STATUS_CONFIG[status];
                    const count = counts[status] || 0;
                    const isLast = i === PIPELINE_STEPS.length - 1;
                    return (
                        <div key={status} className="flex flex-col gap-1 px-5 py-3.5 relative">
                            {/* Progress arrow connector */}
                            {!isLast && (
                                <div className="absolute right-0 top-1/2 -translate-y-1/2 translate-x-1/2 z-10 w-4 h-4 rounded-full bg-white border border-slate-200 flex items-center justify-center">
                                    <svg className="w-2 h-2 text-slate-400" fill="none" viewBox="0 0 8 8">
                                        <path d="M1 4h6M4 1l3 3-3 3" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
                                    </svg>
                                </div>
                            )}
                            <span className={`text-[10px] font-bold uppercase tracking-wider ${cfg.text}`}>{cfg.label}</span>
                            <span className="text-2xl font-bold text-slate-800" style={{ fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.04em' }}>
                                {count}
                            </span>
                        </div>
                    );
                })}
            </div>
            {/* Thin orange accent strip at top */}
            <div className="h-0.5" style={{ background: 'linear-gradient(90deg, #f97316 0%, #fb923c 40%, #fbbf24 100%)' }} />
        </div>
    );
}

// ── Category mapping modal ────────────────────────────────────────────────────

function CategoryMappingModal({ lead, mappings, onClose, onMapped }) {
    const toast = useToast();
    const [slCategories, setSlCategories] = useState([]);
    const [selections, setSelections]     = useState({});
    const [saving, setSaving]             = useState(false);

    const pendingCats = (lead.categories ?? []).filter(cat => {
        const m = mappings.find(m => m.collaboratorCategory === cat);
        return !m || m.status === 'PENDING';
    });

    useEffect(() => {
        fetchWithAuth('/.rest/categories')
            .then(r => r.json())
            .then(data => setSlCategories(data._embedded?.categories ?? []))
            .catch(() => {});
    }, []);

    function setSelection(cat, value) {
        setSelections(prev => ({ ...prev, [cat]: value }));
    }

    const allSelected = pendingCats.every(cat => selections[cat]);

    async function submit() {
        setSaving(true);
        try {
            const resolutions = pendingCats.map(cat => {
                const sel = selections[cat];
                if (sel === 'IGNORE') {
                    return { collaboratorCategory: cat, action: 'IGNORE' };
                }
                const slCat = slCategories.find(c => String(c.id) === String(sel));
                return { collaboratorCategory: cat, action: 'MAP', slCategoryId: slCat.id, slCategoryName: slCat.name };
            });

            const r = await fetchWithAuth('/.rest/engagements/category-mappings/resolve', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(resolutions),
            });
            if (!r.ok) throw new Error(r.status);
            toast('Category mappings saved', 'success');
            onMapped();
        } catch {
            toast('Failed to save mappings', 'error');
        } finally {
            setSaving(false);
        }
    }

    return (
        <Modal title={`Map categories — ${lead.domain}`} dismissHandler={onClose} width="w-full max-w-lg">
            <div className="flex flex-col gap-4">
                <p className="text-slate-500 text-xs leading-relaxed">
                    Map each Collaborator category to a SlinkyLinky category, or choose <strong>Ignore</strong> to skip it.
                    All categories must be resolved before this lead can be actioned.
                </p>

                {pendingCats.length === 0 ? (
                    <p className="text-slate-400 text-sm text-center py-4">No pending categories — this lead is ready to action.</p>
                ) : (
                    <div className="flex flex-col gap-3">
                        {pendingCats.map(cat => (
                            <div key={cat} className="flex items-center gap-3">
                                <span className="flex-1 text-sm font-medium text-slate-700 truncate" title={cat}>{cat}</span>
                                <select
                                    value={selections[cat] ?? ''}
                                    onChange={e => setSelection(cat, e.target.value)}
                                    className="w-48 shrink-0 border border-slate-200 rounded-lg px-2.5 py-1.5 text-sm text-slate-700 bg-white focus:outline-none focus:border-indigo-400 focus:ring-2 focus:ring-indigo-100"
                                >
                                    <option value="">— select —</option>
                                    <option value="IGNORE">— Ignore —</option>
                                    {slCategories.map(c => (
                                        <option key={c.id} value={c.id}>{c.name}</option>
                                    ))}
                                </select>
                            </div>
                        ))}
                    </div>
                )}

                <div className="flex justify-end gap-2 pt-1">
                    <button
                        onClick={onClose}
                        className="text-sm px-3 py-1.5 rounded-lg text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-colors"
                    >
                        Cancel
                    </button>
                    <button
                        onClick={submit}
                        disabled={!allSelected || saving || pendingCats.length === 0}
                        className="text-sm px-4 py-1.5 rounded-lg font-semibold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors border border-indigo-700 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                        {saving ? 'Saving…' : 'Save Mappings'}
                    </button>
                </div>
            </div>
        </Modal>
    );
}

// ── Manual email entry modal ──────────────────────────────────────────────────

function ManualEmailModal({ lead, onClose, onSaved }) {
    const toast = useToast();
    const [email, setEmail]   = useState('');
    const [saving, setSaving] = useState(false);

    async function submit(e) {
        e.preventDefault();
        const trimmed = email.trim();
        if (!trimmed) return;
        setSaving(true);
        try {
            const r = await fetchWithAuth(`/.rest/leads/${lead.id}`, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ contactEmail: trimmed, status: 'CONTACT_FOUND' }),
            });
            if (!r.ok) throw new Error(r.status);
            const updated = await r.json();
            toast(`Contact email set for ${lead.domain}`, 'success');
            onSaved(updated);
        } catch {
            toast('Failed to save contact email', 'error');
        } finally {
            setSaving(false);
        }
    }

    return (
        <Modal title={`Enter contact email — ${lead.domain}`} dismissHandler={onClose} width="w-full max-w-md">
            <form onSubmit={submit} className="flex flex-col gap-4">
                <p className="text-slate-500 text-xs leading-relaxed">
                    Automated discovery couldn't find a contact email for this domain.
                    Enter one manually to continue the outreach process.
                </p>
                <div className="flex flex-col gap-1.5">
                    <label htmlFor="manual-email" className="text-xs font-semibold text-slate-500 uppercase tracking-wide">
                        Email address
                    </label>
                    <input
                        id="manual-email"
                        type="email"
                        required
                        autoFocus
                        value={email}
                        onChange={e => setEmail(e.target.value)}
                        placeholder={`contact@${lead.domain}`}
                        className="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm text-slate-700 placeholder-slate-300 focus:outline-none focus:border-indigo-400 focus:ring-2 focus:ring-indigo-100"
                    />
                </div>
                <div className="flex justify-end gap-2 pt-1">
                    <button
                        type="button"
                        onClick={onClose}
                        className="text-sm px-3 py-1.5 rounded-lg text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-colors"
                    >
                        Cancel
                    </button>
                    <button
                        type="submit"
                        disabled={!email.trim() || saving}
                        className="text-sm px-4 py-1.5 rounded-lg font-semibold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors border border-indigo-700 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                        {saving ? 'Saving…' : 'Save Email'}
                    </button>
                </div>
            </form>
        </Modal>
    );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function LeadsIndex() {
    const { user } = useAuth();
    const navigate = useNavigate();
    const isGlobalAdmin = user?.roles?.includes('global_admin');
    const toast = useToast();

    const [leads, setLeads]               = useState(null);
    const [mappings, setMappings]         = useState([]);
    const [error, setError]               = useState(null);
    const [scraping, setScraping]         = useState(false);
    const [scrapeCount, setScrapeCount]   = useState(0);
    const [busyId, setBusyId]             = useState(null);
    const [showScrapeModal, setShowScrapeModal] = useState(false);
    const [collabAuthSessionId, setCollabAuthSessionId] = useState(null);
    const [collabConnectStatus, setCollabConnectStatus] = useState('IDLE');
    const [collabConnectError, setCollabConnectError] = useState(null);
    const [collabUsername, setCollabUsername] = useState('');
    const [collabPassword, setCollabPassword] = useState('');
    const [cookieInput, setCookieInput] = useState('');
    const [showManualCookieFallback, setShowManualCookieFallback] = useState(false);
    const [manualCookieImporting, setManualCookieImporting] = useState(false);
    const [autoLoggingIn, setAutoLoggingIn] = useState(false);
    const [awaitingTwoFactor, setAwaitingTwoFactor] = useState(false);
    const [twoFactorCode, setTwoFactorCode] = useState('');
    const [submittingTwoFactor, setSubmittingTwoFactor] = useState(false);
    const [scrapeLimit, setScrapeLimit]   = useState(3);
    const [incremental, setIncremental]   = useState(true);
    const [refreshFlash, setRefreshFlash] = useState(false);
    const [confirmModal, setConfirmModal] = useState(null); // { message, confirmLabel, onConfirm }
    const [mappingModalLead, setMappingModalLead] = useState(null);
    const [pendingDiscovery, setPendingDiscovery] = useState(new Set());
    const [autoDiscovering, setAutoDiscovering]   = useState(false);
    const [manualEmailLead, setManualEmailLead]   = useState(null);

    const pollRef              = useRef(null);
    const leadsRef             = useRef(null);
    const autoDiscoverCancel   = useRef(false);

    useEffect(() => {
        if (user && !isGlobalAdmin) navigate('/');
    }, [user, isGlobalAdmin, navigate]);

    useEffect(() => {
        if (!isGlobalAdmin) return;
        fetchLeads();
        fetchMappings();
        checkScrapeStatus();
    }, [isGlobalAdmin]);

    useEffect(() => () => {
        if (pollRef.current) clearInterval(pollRef.current);
    }, []);

    // Keep leadsRef in sync so the polling interval can read the current value
    useEffect(() => { leadsRef.current = leads; }, [leads]);

    // Start polling whenever any lead is searching or browser-queued (even if no scrape is running)
    useEffect(() => {
        if (leads?.some(l => l.status === 'SEARCHING' || l.status === 'BROWSER_QUEUED') && !pollRef.current) {
            startPolling();
        }
    }, [leads]);

    async function fetchLeads(flash = false) {
        try {
            const r = await fetchWithAuth('/.rest/leads');
            if (!r.ok) throw new Error(r.status);
            const data = await r.json();
            setLeads(Array.isArray(data) ? data : (data._embedded?.leads ?? []));
            if (flash) {
                setRefreshFlash(true);
                setTimeout(() => setRefreshFlash(false), 900);
            }
        } catch {
            setError('Could not load leads');
        }
    }

    async function fetchMappings() {
        try {
            const r = await fetchWithAuth('/.rest/engagements/category-mappings');
            if (!r.ok) return;
            setMappings(await r.json());
        } catch { /* non-fatal */ }
    }

    async function checkScrapeStatus() {
        try {
            const r = await fetchWithAuth('/.rest/leads/scrape/status');
            if (!r?.ok) return;
            const data = await r.json();
            if (data.running) {
                setScraping(true);
                setScrapeCount(data.leadsFound);
                startPolling();
            }
        } catch { /* ignore */ }
    }

    function startPolling() {
        if (pollRef.current) return;
        pollRef.current = setInterval(async () => {
            try {
                const r = await fetchWithAuth('/.rest/leads/scrape/status');
                if (!r?.ok) return;
                const data = await r.json();
                setScrapeCount(data.leadsFound);
                await fetchLeads(true);
                // Refresh mappings too — new categories may have appeared
                await fetchMappings();
                const hasBrowserQueued = leadsRef.current?.some(l => l.status === 'BROWSER_QUEUED' || l.status === 'SEARCHING');
                if (!data.running && !hasBrowserQueued) {
                    setScraping(false);
                    clearInterval(pollRef.current);
                    pollRef.current = null;
                    if (data.errorMessage) {
                        toast(`Scrape failed: ${data.errorMessage}`, 'error');
                    }
                } else if (!data.running) {
                    setScraping(false);
                }
            } catch { /* ignore */ }
        }, 5_000);
    }

    async function triggerScrape() {
        setShowScrapeModal(false);
        setScraping(true);
        setScrapeCount(0);
        try {
            const r = await fetchWithAuth('/.rest/leads/scrape', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    authSessionId: collabAuthSessionId,
                    cookies: null,
                    limit: scrapeLimit,
                    incremental,
                }),
            });
            if (r?.status === 409) { setScraping(false); toast('A scrape is already running', 'info'); return; }
            if (!r?.ok) throw new Error(r?.status);
            startPolling();
        } catch {
            setScraping(false);
            toast('Failed to start scrape', 'error');
        }
    }

    async function importManualCookies() {
        const cookieHeader = cookieInput.trim();
        if (!cookieHeader) {
            toast('Paste your Collaborator Cookie header first', 'error');
            return;
        }

        setManualCookieImporting(true);
        setCollabConnectError(null);
        try {
            const r = await fetchWithAuth('/.rest/leads/collaborator/session/import', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ cookieHeader }),
            });
            const data = await r.json();
            if (!r.ok || !data?.authSessionId) {
                throw new Error(data?.errorMessage || data?.error || 'Cookie import failed');
            }

            setCollabAuthSessionId(data.authSessionId);
            localStorage.setItem('sl_collab_session_id', data.authSessionId);
            setCollabConnectStatus('AUTHENTICATED');
            setCookieInput('');
            toast('Manual cookies imported and validated', 'success');
        } catch (e) {
            const msg = e?.message || 'Cookie import failed';
            setCollabConnectStatus('FAILED');
            setCollabConnectError(msg);
            localStorage.removeItem('sl_collab_session_id');
            toast(msg, 'error');
        } finally {
            setManualCookieImporting(false);
        }
    }

    async function autoLogin() {
        setAutoLoggingIn(true);
        setCollabConnectError(null);
        setAwaitingTwoFactor(false);
        setTwoFactorCode('');
        try {
            const r = await fetchWithAuth('/.rest/leads/collaborator/session/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username: collabUsername, password: collabPassword }),
            });
            const data = await r.json();
            if (data?.status === 'AWAITING_2FA') {
                setCollabConnectStatus('AWAITING_2FA');
                setAwaitingTwoFactor(true);
                toast('Check your email for a verification code', 'info');
                return;
            }
            if (!r.ok || !data?.authSessionId) {
                throw new Error(data?.errorMessage || data?.error || 'Auto-login failed');
            }
            setCollabAuthSessionId(data.authSessionId);
            localStorage.setItem('sl_collab_session_id', data.authSessionId);
            setCollabConnectStatus('AUTHENTICATED');
            toast('Logged in to Collaborator.pro automatically', 'success');
        } catch (e) {
            const msg = e?.message || 'Auto-login failed';
            setCollabConnectStatus('FAILED');
            setCollabConnectError(msg);
            localStorage.removeItem('sl_collab_session_id');
            toast(msg, 'error');
        } finally {
            setAutoLoggingIn(false);
        }
    }

    async function submitTwoFactor() {
        if (!twoFactorCode.trim()) return;
        setSubmittingTwoFactor(true);
        setCollabConnectError(null);
        try {
            const r = await fetchWithAuth('/.rest/leads/collaborator/session/login/verify', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ code: twoFactorCode.trim() }),
            });
            const data = await r.json();
            if (!r.ok || !data?.authSessionId) {
                throw new Error(data?.errorMessage || data?.error || 'Verification failed');
            }
            setCollabAuthSessionId(data.authSessionId);
            localStorage.setItem('sl_collab_session_id', data.authSessionId);
            setCollabConnectStatus('AUTHENTICATED');
            setAwaitingTwoFactor(false);
            setTwoFactorCode('');
            toast('Logged in to Collaborator.pro successfully', 'success');
        } catch (e) {
            const msg = e?.message || 'Verification failed';
            setCollabConnectStatus('FAILED');
            setCollabConnectError(msg);
            setAwaitingTwoFactor(false);
            localStorage.removeItem('sl_collab_session_id');
            toast(msg, 'error');
        } finally {
            setSubmittingTwoFactor(false);
        }
    }

    async function discoverContact(lead) {
        setBusyId(lead.id);
        setPendingDiscovery(prev => new Set([...prev, lead.id]));
        try {
            const r = await fetchWithAuth(`/.rest/leads/${lead.id}/discover`, { method: 'POST' });
            if (r?.status === 422) { toast('Resolve category mappings before actioning this lead', 'error'); return; }
            if (!r?.ok) throw new Error(r?.status);
            const updated = await r.json();
            setLeads(prev => prev.map(l => l.id === updated.id ? updated : l));
            if (updated.contactEmail) {
                toast(`Found contact for ${lead.domain}: ${updated.contactEmail}`, 'success');
            } else if (updated.status === 'BROWSER_QUEUED') {
                toast(`${lead.domain} queued for browser discovery`, 'info');
            } else {
                toast(`No contact email found for ${lead.domain}`, 'info');
            }
        } catch {
            toast(`Contact discovery failed for ${lead.domain}`, 'error');
        } finally {
            setBusyId(null);
            setPendingDiscovery(prev => { const s = new Set(prev); s.delete(lead.id); return s; });
        }
    }

    async function startAutoDiscover() {
        const queue = (leads ?? []).filter(l => l.status === 'NEW' && !pendingDiscovery.has(l.id));
        if (!queue.length) return;
        setAutoDiscovering(true);
        autoDiscoverCancel.current = false;
        for (const lead of queue) {
            if (autoDiscoverCancel.current) break;
            await discoverContact(lead);
            if (autoDiscoverCancel.current) break;
            await new Promise(res => setTimeout(res, 2000));
        }
        setAutoDiscovering(false);
    }

    function cancelAutoDiscover() {
        autoDiscoverCancel.current = true;
        setAutoDiscovering(false);
    }

    async function requeueBrowser(lead) {
        setBusyId(lead.id);
        try {
            const r = await fetchWithAuth(`/.rest/leads/${lead.id}/requeueBrowser`, { method: 'POST' });
            if (!r?.ok) throw new Error(r?.status);
            const updated = await r.json();
            setLeads(prev => prev.map(l => l.id === updated.id ? updated : l));
            toast(`${lead.domain} re-queued for browser discovery`, 'info');
        } catch {
            toast(`Failed to re-queue ${lead.domain}`, 'error');
        } finally {
            setBusyId(null);
        }
    }

    function sendOutreach(lead) {
        setConfirmModal({
            message: `Send outreach email to ${lead.contactEmail}?`,
            confirmLabel: 'Send Outreach',
            onConfirm: async () => {
                setBusyId(lead.id);
                try {
                    const r = await fetchWithAuth(`/.rest/leads/${lead.id}/sendOutreach`, { method: 'POST' });
                    if (r?.status === 422) { toast('Resolve category mappings before sending outreach', 'error'); return; }
                    if (!r?.ok) throw new Error(r?.status);
                    const r2 = await fetchWithAuth(`/.rest/leads/${lead.id}`);
                    const updated = await r2.json();
                    setLeads(prev => prev.map(l => l.id === updated.id ? updated : l));
                    toast(`Outreach sent to ${lead.contactEmail}`, 'success');
                } catch {
                    toast('Failed to send outreach email', 'error');
                } finally {
                    setBusyId(null);
                }
            },
        });
    }

    async function downloadFile(lead) {
        const r = await fetchWithAuth(`/.rest/leads/${lead.id}/downloadFile`);
        if (!r?.ok) { toast('File not available', 'error'); return; }
        const blob = await r.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url; a.download = lead.fileName || 'sites.bin'; a.click();
        URL.revokeObjectURL(url);
    }

    function convertToSupplier(lead) {
        setConfirmModal({
            message: `Convert ${lead.domain} to a Supplier?`,
            confirmLabel: 'Convert',
            onConfirm: async () => {
                setBusyId(lead.id);
                try {
                    const r = await fetchWithAuth(`/.rest/leads/${lead.id}/convert`, { method: 'POST' });
                    if (r?.status === 422) { toast('Resolve category mappings before converting', 'error'); return; }
                    if (!r?.ok) throw new Error(r?.status);
                    setLeads(prev => prev.filter(l => l.id !== lead.id));
                    toast(`${lead.domain} converted to Supplier`, 'success');
                } catch {
                    toast('Conversion failed — domain may already be a Supplier', 'error');
                } finally {
                    setBusyId(null);
                }
            },
        });
    }

    function deleteLead(lead) {
        setConfirmModal({
            message: `Delete lead for ${lead.domain}? It will be rediscovered on the next scrape.`,
            confirmLabel: 'Delete',
            onConfirm: async () => {
                setBusyId(lead.id);
                try {
                    const r = await fetchWithAuth(`/.rest/leads/${lead.id}`, { method: 'DELETE' });
                    if (!r?.ok) throw new Error(r?.status);
                    setLeads(prev => prev.filter(l => l.id !== lead.id));
                    toast(`${lead.domain} deleted`, 'success');
                } catch {
                    toast('Failed to delete lead', 'error');
                } finally {
                    setBusyId(null);
                }
            },
        });
    }

    /** Returns category strings for this lead that are still PENDING in the mapping table. */
    function getPendingCategories(lead) {
        return (lead.categories ?? []).filter(cat => {
            const m = mappings.find(m => m.collaboratorCategory === cat);
            return !m || m.status === 'PENDING';
        });
    }

    return (
        <Layout
            pagetitle="Leads"
            headerTitle={
                <span className="flex items-center gap-2">
                    Leads
                    {leads && <span className="text-sm font-normal text-slate-400">({leads.length})</span>}
                    {scraping && (
                        <span className="inline-flex items-center gap-1.5 text-xs font-medium text-orange-600 bg-orange-50 border border-orange-200 rounded-full px-2.5 py-0.5 animate-pulse">
                            <span className="w-1.5 h-1.5 rounded-full bg-orange-400" />
                            Scraping… {scrapeCount} found
                        </span>
                    )}
                </span>
            }
            headerActions={
                <div className="flex items-center gap-2">
                    {leads?.some(l => l.status === 'NEW') && (
                        autoDiscovering ? (
                            <button
                                onClick={cancelAutoDiscover}
                                className="flex items-center gap-1.5 text-sm font-semibold text-white bg-rose-500 hover:bg-rose-600 rounded-lg px-3 py-1.5 transition-colors border border-rose-600"
                            >
                                <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
                                </svg>
                                Cancel auto-discover
                            </button>
                        ) : (
                            <button
                                onClick={startAutoDiscover}
                                disabled={scraping}
                                className="flex items-center gap-1.5 text-sm font-semibold text-white bg-emerald-600 hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg px-3 py-1.5 transition-colors border border-emerald-700"
                            >
                                <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 15.803m10.607 0A7.5 7.5 0 0 0 5.196 15.803" />
                                </svg>
                                Auto-discover contacts
                            </button>
                        )
                    )}
                    <button
                        onClick={async () => {
                            const savedId = localStorage.getItem('sl_collab_session_id');
                            if (savedId) {
                                try {
                                    const r = await fetchWithAuth(`/.rest/leads/collaborator/session/status?sessionId=${encodeURIComponent(savedId)}`);
                                    if (r.ok) {
                                        const data = await r.json();
                                        if (data.status === 'AUTHENTICATED') {
                                            setCollabAuthSessionId(savedId);
                                            setCollabConnectStatus('AUTHENTICATED');
                                            setCollabConnectError(null);
                                            setAwaitingTwoFactor(false);
                                            setTwoFactorCode('');
                                            setShowScrapeModal(true);
                                            return;
                                        }
                                    }
                                } catch { /* fall through to fresh login */ }
                                localStorage.removeItem('sl_collab_session_id');
                            }
                            setCollabConnectStatus('IDLE');
                            setCollabConnectError(null);
                            setAwaitingTwoFactor(false);
                            setTwoFactorCode('');
                            setCollabAuthSessionId(null);
                            setShowScrapeModal(true);
                        }}
                        disabled={scraping}
                        className="flex items-center gap-1.5 text-sm font-semibold text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg px-3 py-1.5 transition-colors border border-indigo-700"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99" />
                        </svg>
                        {scraping ? 'Scraping…' : 'Scrape Collaborator.pro'}
                    </button>
                </div>
            }
        >
            {leads ? (
                leads.length === 0 ? (
                    <div className="flex flex-col items-center justify-center py-24 text-center gap-3">
                        <div className="w-14 h-14 rounded-2xl bg-orange-50 border border-orange-100 flex items-center justify-center">
                            <svg className="w-7 h-7 text-orange-400" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M15.59 14.37a6 6 0 0 1-5.84 7.38v-4.8m5.84-2.58a14.98 14.98 0 0 0 6.16-12.12A14.98 14.98 0 0 0 9.631 8.41m5.96 5.96a14.926 14.926 0 0 1-5.841 2.58m-.119-8.54a6 6 0 0 0-7.381 5.84h4.8m2.581-5.84a14.927 14.927 0 0 0-2.58 5.84m2.699 2.7c-.103.021-.207.041-.311.06a15.09 15.09 0 0 1-2.448-2.448 14.9 14.9 0 0 1 .06-.312m-2.24 2.39a4.493 4.493 0 0 0-1.757 4.306 4.493 4.493 0 0 0 4.306-1.758M16.5 9a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Z" />
                            </svg>
                        </div>
                        <p className="text-slate-600 font-medium text-sm">No leads yet</p>
                        <p className="text-slate-400 text-xs max-w-xs">Click "Scrape Collaborator.pro" to populate this table with potential supplier domains.</p>
                    </div>
                ) : (
                    <>
                        <PipelineBar leads={leads} />
                        <div className="px-6 pb-6">
                            {(scraping || leads?.some(l => l.status === 'BROWSER_QUEUED' || l.status === 'SEARCHING')) && (
                                <div className="flex items-center gap-3 text-[11px] text-slate-400 mb-2 px-0.5">
                                    <span className="flex items-center gap-1.5">
                                        <svg className="w-3 h-3 animate-spin shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                                        </svg>
                                        Auto-updating every 5s
                                    </span>
                                    {leads?.some(l => l.status === 'SEARCHING') && (
                                        <span className="text-amber-500">
                                            {leads.filter(l => l.status === 'SEARCHING').length} domain{leads.filter(l => l.status === 'SEARCHING').length !== 1 ? 's' : ''} searching for contact
                                        </span>
                                    )}
                                    {leads?.some(l => l.status === 'BROWSER_QUEUED') && (
                                        <span className="text-violet-500">
                                            {leads.filter(l => l.status === 'BROWSER_QUEUED').length} domain{leads.filter(l => l.status === 'BROWSER_QUEUED').length !== 1 ? 's' : ''} pending browser discovery
                                        </span>
                                    )}
                                </div>
                            )}
                            <div className={`bg-white rounded-xl border shadow-sm overflow-hidden transition-all duration-300 ${refreshFlash ? 'ring-2 ring-orange-300 border-orange-300' : 'border-slate-200'}`}>
                                <table className="w-full text-sm border-collapse">
                                    <thead>
                                        <tr className="border-b border-slate-100 text-left">
                                            <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Domain</th>
                                            <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Price</th>
                                            <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Categories</th>
                                            <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Contact</th>
                                            <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Status</th>
                                            <th className="px-4 py-3 text-[11px] font-semibold text-slate-500 uppercase tracking-wide">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-slate-50">
                                        {leads.map((lead, index) => {
                                            const pendingCats = getPendingCategories(lead);
                                            const hasUnmapped = pendingCats.length > 0;
                                            return (
                                                <tr key={lead.id ?? `${lead.domain ?? 'lead'}-${index}`} className="hover:bg-slate-50 transition-colors group">
                                                    <td className="px-4 py-2.5 font-mono text-xs max-w-[200px] font-medium">
                                                        <div className="flex items-center gap-1.5 min-w-0">
                                                            <a
                                                                href={`https://${lead.domain}`}
                                                                target="_blank"
                                                                rel="noopener noreferrer"
                                                                className="text-indigo-600 hover:text-indigo-800 hover:underline transition-colors truncate"
                                                            >
                                                                {lead.domain}
                                                            </a>
                                                            {hasUnmapped && (
                                                                <span
                                                                    title={`${pendingCats.length} unmapped categor${pendingCats.length === 1 ? 'y' : 'ies'}: ${pendingCats.join(', ')}`}
                                                                    className="shrink-0 inline-flex items-center gap-1 rounded-full px-1.5 py-0.5 text-[10px] font-semibold bg-amber-100 text-amber-700 border border-amber-200"
                                                                >
                                                                    <svg className="w-2.5 h-2.5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                                                                        <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
                                                                    </svg>
                                                                    {pendingCats.length}
                                                                </span>
                                                            )}
                                                        </div>
                                                    </td>
                                                    <td className="px-4 py-2.5 text-slate-700 whitespace-nowrap text-sm font-medium">
                                                        {lead.price ? `${lead.currency ?? ''} ${lead.price}` : <span className="text-slate-300">—</span>}
                                                    </td>
                                                    <td className="px-4 py-2.5 text-slate-500 text-xs max-w-[180px] truncate" title={lead.categories?.join(' | ')}>
                                                        {lead.categories?.length ? lead.categories.join(' | ') : <span className="text-slate-300">—</span>}
                                                    </td>
                                                    <td className="px-4 py-2.5 text-slate-500 text-xs max-w-[160px] truncate">
                                                        {lead.contactEmail || <span className="text-slate-300">—</span>}
                                                    </td>
                                                    <td className="px-4 py-2.5">
                                                        <StatusBadge status={lead.status} />
                                                    </td>
                                                    <td className="px-4 py-2.5">
                                                        <div className="flex items-center gap-1">
                                                            {hasUnmapped && (
                                                                <ActionBtn
                                                                    label="Map Categories"
                                                                    variant="warning"
                                                                    onClick={() => setMappingModalLead(lead)}
                                                                    disabled={busyId === lead.id}
                                                                />
                                                            )}
                                                            {lead.status === 'NEW' && !pendingDiscovery.has(lead.id) && (
                                                                <ActionBtn
                                                                    label="Find Contact"
                                                                    onClick={() => discoverContact(lead)}
                                                                    disabled={busyId === lead.id || hasUnmapped}
                                                                    title={hasUnmapped ? 'Resolve category mappings first' : undefined}
                                                                />
                                                            )}
                                                            {lead.status === 'SEARCHING' && (
                                                                <span className="text-xs text-amber-500 italic px-1">Searching…</span>
                                                            )}
                                                            {lead.status === 'BROWSER_QUEUED' && (
                                                                <span className="text-xs text-violet-500 italic px-1">Browser queued…</span>
                                                            )}
                                                            {lead.status === 'CONTACT_NOT_FOUND' && (
                                                                <>
                                                                    <ActionBtn label="Retry Browser" onClick={() => requeueBrowser(lead)} disabled={busyId === lead.id} />
                                                                    <ActionBtn label="Enter Email" variant="primary" onClick={() => setManualEmailLead(lead)} disabled={busyId === lead.id} />
                                                                </>
                                                            )}
                                                            {lead.contactEmail && lead.status === 'CONTACT_FOUND' && (
                                                                <ActionBtn
                                                                    label="Send Outreach"
                                                                    variant="primary"
                                                                    onClick={() => sendOutreach(lead)}
                                                                    disabled={busyId === lead.id || hasUnmapped}
                                                                    title={hasUnmapped ? 'Resolve category mappings first' : undefined}
                                                                />
                                                            )}
                                                            {lead.status === 'ACCEPTED' && lead.fileBlob && (
                                                                <ActionBtn label="Download File" onClick={() => downloadFile(lead)} disabled={busyId === lead.id} />
                                                            )}
                                                            {lead.status === 'ACCEPTED' && (
                                                                <ActionBtn
                                                                    label="Convert to Supplier"
                                                                    variant="success"
                                                                    onClick={() => convertToSupplier(lead)}
                                                                    disabled={busyId === lead.id || hasUnmapped}
                                                                    title={hasUnmapped ? 'Resolve category mappings first' : undefined}
                                                                />
                                                            )}
                                                            <ActionBtn label="Delete" variant="ghost" onClick={() => deleteLead(lead)} disabled={busyId === lead.id} />
                                                        </div>
                                                    </td>
                                                </tr>
                                            );
                                        })}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </>
                )
            ) : (
                <Loading error={error} />
            )}

            {confirmModal && (
                <Modal title="Confirm" dismissHandler={() => setConfirmModal(null)}>
                    <p className="text-slate-600 text-sm leading-relaxed">{confirmModal.message}</p>
                    <div className="flex justify-end gap-2 pt-1">
                        <button
                            onClick={() => setConfirmModal(null)}
                            className="text-sm px-3 py-1.5 rounded-lg text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-colors"
                        >
                            Cancel
                        </button>
                        <button
                            onClick={() => { setConfirmModal(null); confirmModal.onConfirm(); }}
                            className="text-sm px-4 py-1.5 rounded-lg font-semibold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors border border-indigo-700"
                        >
                            {confirmModal.confirmLabel ?? 'Confirm'}
                        </button>
                    </div>
                </Modal>
            )}

            {showScrapeModal && (
                <Modal title="Scrape Collaborator.pro" dismissHandler={() => setShowScrapeModal(false)} width="w-full max-w-lg" dismissOnBackdropClick={false}>
                    <div className="flex flex-col gap-4">
                        <p className="text-slate-600 text-sm leading-relaxed">
                            Enter your Collaborator.pro credentials to log in and start scraping.
                        </p>

                        <div
                            className="rounded-lg border border-slate-200 bg-white p-3 flex flex-col gap-2"
                            style={{ position: 'relative', overflow: 'hidden' }}
                        >
                            {/* Sweeping progress bar during login/verify */}
                            {(autoLoggingIn || submittingTwoFactor) && (
                                <div style={{
                                    position: 'absolute', top: 0, left: 0, right: 0, height: 2,
                                    background: 'rgba(99,102,241,0.1)',
                                }}>
                                    <div style={{
                                        position: 'absolute', top: 0, height: '100%',
                                        width: '50%',
                                        background: 'linear-gradient(90deg, transparent 0%, #6366f1 50%, transparent 100%)',
                                        animation: 'sl-login-progress 1.4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
                                    }} />
                                </div>
                            )}
                            <div className="flex items-center justify-between gap-3">
                                <span className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Collaborator Login</span>
                                <span className={`text-[11px] font-semibold px-2 py-0.5 rounded-full inline-flex items-center gap-1 ${
                                    autoLoggingIn || submittingTwoFactor
                                        ? 'bg-indigo-50 text-indigo-600'
                                        : collabConnectStatus === 'AUTHENTICATED'
                                            ? 'bg-emerald-100 text-emerald-700'
                                            : collabConnectStatus === 'FAILED' || collabConnectStatus === 'EXPIRED'
                                                ? 'bg-rose-100 text-rose-700'
                                                : collabConnectStatus === 'AWAITING_2FA'
                                                    ? 'bg-amber-100 text-amber-700'
                                                    : 'bg-slate-100 text-slate-600'
                                }`}>
                                    {autoLoggingIn ? (
                                        <>
                                            Connecting
                                            {[0, 150, 300].map(d => (
                                                <span key={d} style={{
                                                    width: 3, height: 3, borderRadius: '50%',
                                                    background: 'currentColor', display: 'inline-block',
                                                    animation: 'sl-loading-dot 1.2s ease-in-out infinite',
                                                    animationDelay: `${d}ms`,
                                                }} />
                                            ))}
                                        </>
                                    ) : submittingTwoFactor ? (
                                        <>
                                            Verifying
                                            {[0, 150, 300].map(d => (
                                                <span key={d} style={{
                                                    width: 3, height: 3, borderRadius: '50%',
                                                    background: 'currentColor', display: 'inline-block',
                                                    animation: 'sl-loading-dot 1.2s ease-in-out infinite',
                                                    animationDelay: `${d}ms`,
                                                }} />
                                            ))}
                                        </>
                                    ) : (
                                        collabConnectStatus === 'IDLE' ? 'Not logged in'
                                        : collabConnectStatus === 'AUTHENTICATED' ? 'Ready to scrape'
                                        : collabConnectStatus === 'AWAITING_2FA' ? 'Check email for code'
                                        : collabConnectStatus
                                    )}
                                </span>
                            </div>

                            {collabConnectError && (
                                <p className="text-xs text-rose-600">{collabConnectError}</p>
                            )}

                            {/* Credential fields — wrapped in a form so Chrome's password manager can save/fill them */}
                            <form
                                action="https://collaborator.pro"
                                method="post"
                                onSubmit={e => { e.preventDefault(); autoLogin(); }}
                                className="flex flex-col gap-2 pt-1"
                            >
                                <div className="flex flex-col gap-1">
                                    <label htmlFor="collab-username" className="text-[11px] font-semibold text-slate-400 uppercase tracking-wide">
                                        Collaborator.pro email
                                    </label>
                                    <input
                                        id="collab-username"
                                        type="email"
                                        autoComplete="username"
                                        value={collabUsername}
                                        onChange={e => setCollabUsername(e.target.value)}
                                        disabled={autoLoggingIn || submittingTwoFactor || collabConnectStatus === 'AUTHENTICATED'}
                                        placeholder="you@example.com"
                                        className="w-full border border-slate-200 rounded-lg px-3 py-1.5 text-sm text-slate-700 placeholder-slate-300 focus:outline-none focus:border-indigo-400 focus:ring-2 focus:ring-indigo-100 disabled:bg-slate-50 disabled:text-slate-400"
                                    />
                                </div>
                                <div className="flex flex-col gap-1">
                                    <label htmlFor="collab-password" className="text-[11px] font-semibold text-slate-400 uppercase tracking-wide">
                                        Password
                                    </label>
                                    <input
                                        id="collab-password"
                                        type="password"
                                        autoComplete="current-password"
                                        value={collabPassword}
                                        onChange={e => setCollabPassword(e.target.value)}
                                        disabled={autoLoggingIn || submittingTwoFactor || collabConnectStatus === 'AUTHENTICATED'}
                                        placeholder="••••••••"
                                        className="w-full border border-slate-200 rounded-lg px-3 py-1.5 text-sm text-slate-700 placeholder-slate-300 focus:outline-none focus:border-indigo-400 focus:ring-2 focus:ring-indigo-100 disabled:bg-slate-50 disabled:text-slate-400"
                                    />
                                </div>

                                <div className="flex gap-2 pt-1 flex-wrap">
                                    <button
                                        type="submit"
                                        disabled={autoLoggingIn || submittingTwoFactor || collabConnectStatus === 'AUTHENTICATED' || !collabUsername.trim() || !collabPassword}
                                        className="text-xs px-3 py-1.5 rounded-lg border border-indigo-200 text-indigo-700 bg-indigo-50 hover:bg-indigo-100 transition-colors font-semibold disabled:opacity-40 disabled:cursor-not-allowed"
                                    >
                                        {autoLoggingIn ? 'Logging in…' : 'Auto Login'}
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setShowManualCookieFallback(v => !v)}
                                        className="text-xs px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-50 transition-colors"
                                    >
                                        {showManualCookieFallback ? 'Hide Manual Cookie Fallback' : 'Use Manual Cookie Fallback'}
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => window.open('https://collaborator.pro/catalog/creator/article', '_blank', 'noopener,noreferrer')}
                                        className="text-xs px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-50 transition-colors"
                                    >
                                        Open Collaborator
                                    </button>
                                </div>
                            </form>

                            {awaitingTwoFactor && (
                                <div className="mt-2 flex items-center gap-2">
                                    <input
                                        type="text"
                                        value={twoFactorCode}
                                        onChange={e => setTwoFactorCode(e.target.value)}
                                        onKeyDown={e => e.key === 'Enter' && submitTwoFactor()}
                                        placeholder="Enter verification code from email"
                                        className="text-xs px-2 py-1.5 rounded border border-indigo-300 flex-1 font-mono focus:outline-none focus:ring-1 focus:ring-indigo-400"
                                        maxLength={12}
                                        autoFocus
                                    />
                                    <button
                                        type="button"
                                        onClick={submitTwoFactor}
                                        disabled={submittingTwoFactor || !twoFactorCode.trim()}
                                        className="text-xs px-3 py-1.5 rounded-lg border border-emerald-200 text-emerald-700 bg-emerald-50 hover:bg-emerald-100 transition-colors font-semibold disabled:opacity-40 disabled:cursor-not-allowed whitespace-nowrap"
                                    >
                                        {submittingTwoFactor ? 'Verifying…' : 'Submit Code'}
                                    </button>
                                </div>
                            )}
                        </div>

                        {showManualCookieFallback && (
                            <div className="rounded-lg border border-amber-200 bg-amber-50 p-3 flex flex-col gap-2">
                                <p className="text-xs text-amber-800">
                                    Fallback mode: paste the Cookie header value, then import it for server-side validation.
                                </p>
                                <textarea
                                    value={cookieInput}
                                    onChange={e => setCookieInput(e.target.value)}
                                    placeholder="langCode=en; cf_clearance=...; _identity-user=..."
                                    rows={4}
                                    className="w-full bg-white border border-amber-200 rounded-lg px-3 py-2 text-xs text-slate-700 font-mono placeholder-slate-300 focus:outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 resize-none"
                                />
                                <div className="flex justify-end">
                                    <button
                                        type="button"
                                        onClick={importManualCookies}
                                        disabled={!cookieInput.trim() || manualCookieImporting}
                                        className="text-xs px-3 py-1.5 rounded-lg font-semibold text-amber-900 bg-amber-200 hover:bg-amber-300 transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                                    >
                                        {manualCookieImporting ? 'Importing…' : 'Import Cookies'}
                                    </button>
                                </div>
                            </div>
                        )}

                        {/* Limit selector */}
                        <div className="flex flex-col gap-2">
                            <span className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Stop after</span>
                            <div className="grid grid-cols-4 gap-2">
                                {[
                                    { value: 3,    label: '3',  sub: 'Quick test' },
                                    { value: 20,   label: '20', sub: 'Standard'   },
                                    { value: 100,  label: '100',sub: 'Deep crawl' },
                                    { value: null, label: '∞',  sub: 'No limit'   },
                                ].map(({ value, label, sub }) => {
                                    const active = scrapeLimit === value;
                                    return (
                                        <button
                                            key={String(value)}
                                            type="button"
                                            onClick={() => setScrapeLimit(value)}
                                            className={`flex flex-col items-center gap-0.5 rounded-xl border px-3 py-2.5 transition-all focus:outline-none ${
                                                active
                                                    ? 'border-indigo-500 bg-indigo-50 shadow-sm ring-1 ring-indigo-300'
                                                    : 'border-slate-200 bg-white hover:border-slate-300 hover:bg-slate-50'
                                            }`}
                                        >
                                            <span className={`text-xl font-bold leading-none ${active ? 'text-indigo-700' : 'text-slate-700'}`}>
                                                {label}
                                            </span>
                                            <span className={`text-[10px] font-medium ${active ? 'text-indigo-400' : 'text-slate-400'}`}>
                                                {sub}
                                            </span>
                                        </button>
                                    );
                                })}
                            </div>
                        </div>

                        {/* Incremental toggle */}
                        <div className="flex items-center justify-between rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5">
                            <div className="flex flex-col gap-0.5">
                                <span className="text-xs font-semibold text-slate-700">Incremental mode</span>
                                <span className="text-[11px] text-slate-400">Skip pages already in the database</span>
                            </div>
                            <button
                                type="button"
                                onClick={() => setIncremental(v => !v)}
                                className={`relative inline-flex h-5 w-9 shrink-0 items-center rounded-full transition-colors focus:outline-none ${incremental ? 'bg-indigo-600' : 'bg-slate-200'}`}
                            >
                                <span className={`inline-block h-3.5 w-3.5 transform rounded-full bg-white shadow transition-transform ${incremental ? 'translate-x-4' : 'translate-x-1'}`} />
                            </button>
                        </div>

                        <div className="flex justify-end gap-2 pt-1">
                            <button
                                onClick={() => setShowScrapeModal(false)}
                                className="text-sm px-3 py-1.5 rounded-lg text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-colors"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={triggerScrape}
                                disabled={collabConnectStatus !== 'AUTHENTICATED'}
                                className="text-sm px-4 py-1.5 rounded-lg font-semibold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors border border-indigo-700 disabled:opacity-40 disabled:cursor-not-allowed"
                            >
                                Start Scrape
                            </button>
                        </div>
                    </div>
                </Modal>
            )}

            {manualEmailLead && (
                <ManualEmailModal
                    lead={manualEmailLead}
                    onClose={() => setManualEmailLead(null)}
                    onSaved={(updated) => {
                        setManualEmailLead(null);
                        setLeads(prev => prev.map(l => l.id === updated.id ? updated : l));
                    }}
                />
            )}

            {mappingModalLead && (
                <CategoryMappingModal
                    lead={mappingModalLead}
                    mappings={mappings}
                    onClose={() => setMappingModalLead(null)}
                    onMapped={async () => {
                        setMappingModalLead(null);
                        await fetchMappings();
                    }}
                />
            )}
        </Layout>
    );
}
