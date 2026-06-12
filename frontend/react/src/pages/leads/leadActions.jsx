// Shared lead UI primitives for the Leads page:
//   - STATUS_CONFIG / PIPELINE_STEPS / StatusBadge
//   - Icon + toneClasses helpers
//   - buildLeadActions(lead, ctx): the single source of truth for which actions a
//     lead exposes in its current state. Used both for the inline row primary action
//     and for the full action list inside the lead drawer.

// ── Status config ─────────────────────────────────────────────────────────────

export const STATUS_CONFIG = {
    NEW:               { label: 'New',              bg: 'bg-slate-100',   text: 'text-slate-600',   dot: '#94a3b8' },
    SEARCHING:         { label: 'Searching',        bg: 'bg-amber-100',   text: 'text-amber-700',   dot: '#f59e0b' },
    BROWSER_QUEUED:    { label: 'Browser Queued',   bg: 'bg-violet-100',  text: 'text-violet-700',  dot: '#7c3aed' },
    CONTACT_FOUND:     { label: 'Contact Found',    bg: 'bg-amber-100',   text: 'text-amber-700',   dot: '#f59e0b' },
    CONTACT_NOT_FOUND: { label: 'Not Found',        bg: 'bg-rose-100',    text: 'text-rose-600',    dot: '#f43f5e' },
    OUTREACH_SENT:     { label: 'Outreach Sent',    bg: 'bg-blue-100',    text: 'text-blue-700',    dot: '#3b82f6' },
    ACCEPTED:          { label: 'Accepted',         bg: 'bg-emerald-100', text: 'text-emerald-700', dot: '#10b981' },
    DECLINED:          { label: 'Declined',         bg: 'bg-red-100',     text: 'text-red-600',     dot: '#ef4444' },
};

export const PIPELINE_STEPS = ['NEW', 'BROWSER_QUEUED', 'CONTACT_FOUND', 'OUTREACH_SENT', 'ACCEPTED'];

export function StatusBadge({ status }) {
    const cfg = STATUS_CONFIG[status] ?? STATUS_CONFIG.NEW;
    return (
        <span className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-[11px] font-semibold ${cfg.bg} ${cfg.text}`}>
            <span className="w-1.5 h-1.5 rounded-full shrink-0" style={{ background: cfg.dot }} />
            {cfg.label}
        </span>
    );
}

// ── Icons (heroicons-style single paths) ─────────────────────────────────────

const ICON_PATHS = {
    search:   'M21 21l-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 15.803m10.607 0A7.5 7.5 0 0 0 5.196 15.803',
    tag:      'M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581a2.25 2.25 0 0 0 3.182 0l4.318-4.318a2.25 2.25 0 0 0 0-3.182l-9.58-9.581A2.25 2.25 0 0 0 9.567 3ZM6 6h.008v.008H6V6Z',
    mail:     'M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75',
    send:     'M6 12 3.269 3.126A59.768 59.768 0 0 1 21.485 12 59.77 59.77 0 0 1 3.27 20.876L5.999 12Zm0 0h7.5',
    refresh:  'M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99',
    convert:  'M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z',
    download: 'M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3',
    review:   'M11.48 3.499a.562.562 0 0 1 1.04 0l2.125 5.111a.563.563 0 0 0 .475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 0 0-.182.557l1.285 5.385a.562.562 0 0 1-.84.61l-4.725-2.885a.562.562 0 0 0-.586 0L6.982 20.54a.562.562 0 0 1-.84-.61l1.285-5.386a.562.562 0 0 0-.182-.557l-4.204-3.602a.562.562 0 0 1 .321-.988l5.518-.442a.563.563 0 0 0 .475-.345L11.48 3.5Z',
    edit:     'M16.862 4.487l1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L6.832 19.82a4.5 4.5 0 0 1-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 0 1 1.13-1.897L16.863 4.487Zm0 0L19.5 7.125',
    copy:     'M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 0 1-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H6.75a9.06 9.06 0 0 1 1.5.124m7.5 10.376h3.375c.621 0 1.125-.504 1.125-1.125V11.25c0-4.46-3.243-8.161-7.5-8.876a9.06 9.06 0 0 0-1.5-.124H9.375c-.621 0-1.125.504-1.125 1.125v3.5m7.5 10.375H9.375a1.125 1.125 0 0 1-1.125-1.125v-9.25m12 6.625v-1.875a3.375 3.375 0 0 0-3.375-3.375h-1.5a1.125 1.125 0 0 1-1.125-1.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H9.75',
    external: 'M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25',
    trash:    'm14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0',
    restore:  'M9 15 3 9m0 0 6-6M3 9h12a6 6 0 0 1 0 12h-3',
    chevron:  'm8.25 4.5 7.5 7.5-7.5 7.5',
};

export function Icon({ name, className = 'w-4 h-4' }) {
    const d = ICON_PATHS[name];
    if (!d) return null;
    return (
        <svg className={className} fill="none" viewBox="0 0 24 24" strokeWidth={1.7} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d={d} />
        </svg>
    );
}

// Tailwind classes for a bordered action button/row, keyed by tone.
export function toneClasses(tone) {
    switch (tone) {
        case 'primary': return 'text-white bg-indigo-600 hover:bg-indigo-700 border-indigo-700';
        case 'success': return 'text-white bg-emerald-600 hover:bg-emerald-700 border-emerald-700';
        case 'warning': return 'text-amber-800 bg-amber-50 hover:bg-amber-100 border-amber-300';
        case 'danger':  return 'text-rose-600 bg-white hover:bg-rose-50 border-rose-200';
        default:        return 'text-slate-700 bg-white hover:bg-slate-50 border-slate-200';
    }
}

// ── Action model ──────────────────────────────────────────────────────────────
//
// Returns { primary, secondary[], danger[], waiting } for a lead in its current
// state. Each action is { key, label, icon, tone, disabled, disabledHint,
// closesDrawer, run }. `waiting` (a string) is returned for passive states that
// have no primary action (Searching, Awaiting reply, Declined).
//
// ctx = {
//   pendingCats: string[],   // unresolved Collaborator categories (gates the pipeline)
//   busy:        boolean,     // an action for this lead is in flight
//   isDismissed: boolean,     // lead is a dismissed tombstone
//   on: { map, find, retryBrowser, enterEmail, sendOutreach, downloadFile,
//         reviewCategories, convert, dismiss, undismiss, visitSite, copyDomain }
// }
export function buildLeadActions(lead, ctx) {
    const { pendingCats = [], busy = false, isDismissed = false, on = {} } = ctx;
    const hasUnmapped = pendingCats.length > 0;
    const A = (o) => ({ tone: 'neutral', closesDrawer: false, disabled: false, ...o });

    const utility = [
        A({ key: 'visit', label: 'Visit site',  icon: 'external', run: on.visitSite }),
        A({ key: 'copy',  label: 'Copy domain', icon: 'copy',     run: on.copyDomain }),
    ];

    if (isDismissed) {
        return {
            primary: A({ key: 'undismiss', label: 'Restore lead', icon: 'restore', tone: 'primary', closesDrawer: true, disabled: busy, run: on.undismiss }),
            secondary: utility,
            danger: [],
        };
    }

    const dismiss = A({ key: 'dismiss', label: 'Dismiss lead', icon: 'trash', tone: 'danger', closesDrawer: true, disabled: busy, run: on.dismiss });

    // Unmapped categories gate the whole pipeline → promote resolving them to primary.
    if (hasUnmapped) {
        const n = pendingCats.length;
        return {
            primary: A({ key: 'map', label: `Map ${n} categor${n === 1 ? 'y' : 'ies'}`, icon: 'tag', tone: 'warning', closesDrawer: true, disabled: busy, run: on.map }),
            secondary: utility,
            danger: [dismiss],
        };
    }

    switch (lead.status) {
        case 'NEW':
            return {
                primary: A({ key: 'find', label: 'Find contact', icon: 'search', tone: 'primary', disabled: busy, run: on.find }),
                secondary: utility, danger: [dismiss],
            };
        case 'SEARCHING':
            return { waiting: 'Searching for contact…', secondary: utility, danger: [dismiss] };
        case 'BROWSER_QUEUED':
            return { waiting: 'Queued for browser…', secondary: utility, danger: [dismiss] };
        case 'CONTACT_FOUND':
            return {
                primary: lead.contactEmail
                    ? A({ key: 'outreach', label: 'Send outreach', icon: 'send', tone: 'primary', disabled: busy, run: on.sendOutreach })
                    : null,
                secondary: utility, danger: [dismiss],
            };
        case 'CONTACT_NOT_FOUND':
            return {
                primary: A({ key: 'enterEmail', label: 'Enter email', icon: 'mail', tone: 'primary', closesDrawer: true, disabled: busy, run: on.enterEmail }),
                secondary: [
                    A({ key: 'retry', label: 'Retry browser discovery', icon: 'refresh', disabled: busy, run: on.retryBrowser }),
                    ...utility,
                ],
                danger: [dismiss],
            };
        case 'OUTREACH_SENT':
            return { waiting: 'Awaiting reply', secondary: utility, danger: [dismiss] };
        case 'ACCEPTED': {
            const needsReview = lead.categorySuggestion && !lead.categorySuggestionReviewed;
            const sec = [];
            if (lead.categorySuggestion)
                sec.push(A({ key: 'review', label: 'Review categories', icon: 'review', tone: 'warning', closesDrawer: true, disabled: busy, run: on.reviewCategories }));
            if (lead.fileBlob)
                sec.push(A({ key: 'download', label: 'Download file', icon: 'download', disabled: busy, run: on.downloadFile }));
            sec.push(...utility);
            return {
                primary: A({
                    key: 'convert', label: 'Convert to Supplier', icon: 'convert', tone: 'success', closesDrawer: true,
                    disabled: busy || needsReview,
                    disabledHint: needsReview ? 'Review the category suggestion first' : undefined,
                    run: on.convert,
                }),
                secondary: sec, danger: [dismiss],
            };
        }
        case 'DECLINED':
            return {
                waiting: lead.declineReason ? `Declined — ${lead.declineReason}` : 'Declined',
                secondary: utility, danger: [dismiss],
            };
        default:
            return { secondary: utility, danger: [dismiss] };
    }
}
