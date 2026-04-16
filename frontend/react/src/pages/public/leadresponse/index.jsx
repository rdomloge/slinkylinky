import { useSearchParams } from 'react-router-dom';
import { useEffect, useState } from 'react';
import './leadresponse.css';

// ── Local primitives (mirror supplierresponse pattern) ───────────────────────

function SrButton({ children, onClick, variant = 'accent', disabled = false }) {
    return (
        <button type="button" onClick={onClick} disabled={disabled}
            className={`sr-btn sr-btn--${variant}`}>
            {children}
        </button>
    );
}

function SrInput({ label, value, onChange, placeholder = '' }) {
    return (
        <div className="sr-input-group">
            <label className="sr-label">{label}</label>
            <input className="sr-input" value={value}
                onChange={e => onChange(e.target.value)} placeholder={placeholder} />
        </div>
    );
}

function SrModal({ children, onClose, title }) {
    const handleOverlay = e => { if (e.target === e.currentTarget) onClose(); };
    return (
        <div className="sr-modal-overlay" onClick={handleOverlay}>
            <div className="sr-modal">
                <div className="sr-modal-header">
                    <span className="sr-modal-title">{title}</span>
                    <button className="sr-modal-close" onClick={onClose} aria-label="Close">✕</button>
                </div>
                <div className="sr-modal-body">{children}</div>
            </div>
        </div>
    );
}

function SrLoading() {
    return (
        <div className="sr-loading">
            <div className="sr-loading__ring" />
            <p className="sr-loading__text">Loading your invitation</p>
        </div>
    );
}

function SrNotFound() {
    return (
        <div className="sr-notfound">
            <span className="sr-notfound__code">404</span>
            <p className="sr-notfound__msg">This invitation link is invalid or has expired.</p>
        </div>
    );
}

function SrResponded({ status }) {
    const accepted = status === 'ACCEPTED';
    return (
        <div className={`sr-responded sr-responded--${accepted ? 'accepted' : 'declined'}`}>
            <div className="sr-responded__tag">
                {accepted ? '✓  Invitation Accepted' : 'Invitation Declined'}
            </div>
            <h1 className="sr-responded__headline">
                {accepted ? 'Welcome aboard.' : 'Understood.'}
            </h1>
            <p className="sr-responded__sub">
                {accepted
                    ? 'Thanks for registering your interest. Our team will be in touch shortly.'
                    : 'Thanks for letting us know. We\'ll remove you from our list.'}
            </p>
        </div>
    );
}

function LogoIcon() {
    return (
        <div className="sr-header__icon">
            <svg viewBox="0 0 14 14" fill="none" width="10" height="10">
                <path d="M3 7 C3 4.8 4.8 3 7 3 S11 4.8 11 7 9.2 11 7 11"
                    stroke="white" strokeWidth="1.8" strokeLinecap="round"/>
                <circle cx="3" cy="11" r="1.5" fill="white" opacity="0.7"/>
            </svg>
        </div>
    );
}

function LockIcon() {
    return (
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"
            strokeLinecap="round" strokeLinejoin="round" width="11" height="11">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
            <path d="M7 11V7a5 5 0 0 1 10 0v4" />
        </svg>
    );
}

// ── Page ──────────────────────────────────────────────────────────────────────

export default function LeadResponse() {
    const [searchParams] = useSearchParams();

    const [lead, setLead]                     = useState(null);
    const [guidError, setGuidError]           = useState(null);
    const [showAcceptModal, setShowAcceptModal] = useState(false);
    const [showDeclineModal, setShowDeclineModal] = useState(false);
    const [googleDocUrl, setGoogleDocUrl]     = useState('');
    const [file, setFile]                     = useState(null);
    const [declineReason, setDeclineReason]   = useState('');
    const [submitting, setSubmitting]         = useState(false);
    const [acceptError, setAcceptError]       = useState(null);

    useEffect(() => {
        document.body.style.backgroundColor = '#060B18';
        document.title = 'Slinky Linky | Partnership Invitation';
        return () => { document.body.style.backgroundColor = ''; };
    }, []);

    useEffect(() => {
        const guid = searchParams.get('guid');
        if (!guid) { setGuidError(true); return; }
        fetch('/.rest/leads/response?guid=' + guid)
            .then(r => r.ok ? r.json() : Promise.reject(r))
            .then(data => setLead(data))
            .catch(() => setGuidError(true));
    }, [searchParams]);

    const handleAccept = async () => {
        setAcceptError(null);
        setSubmitting(true);
        const guid = searchParams.get('guid');
        const fd = new FormData();
        if (googleDocUrl.trim()) fd.append('googleDocUrl', googleDocUrl.trim());
        if (file) fd.append('file', file);

        try {
            const r = await fetch(`/.rest/leads/accept?guid=${guid}`, {
                method: 'PATCH',
                body: fd,
            });
            if (r.ok) {
                setShowAcceptModal(false);
                window.location.reload();
            } else {
                setAcceptError('Something went wrong. Please try again.');
            }
        } catch {
            setAcceptError('Network error. Please try again.');
        } finally {
            setSubmitting(false);
        }
    };

    const handleDecline = async () => {
        setSubmitting(true);
        const guid = searchParams.get('guid');
        try {
            const r = await fetch(`/.rest/leads/decline?guid=${guid}`, {
                method: 'PATCH',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ declineReason }),
            });
            if (r.ok) window.location.reload();
        } catch { /* ignore */ }
        finally { setSubmitting(false); }
    };

    const isResponded = lead && (lead.status === 'ACCEPTED' || lead.status === 'DECLINED');

    return (
        <div className="sr-root">
            {guidError && <SrNotFound />}
            {!lead && !guidError && <SrLoading />}

            {lead && (
                <>
                    <header className="sr-header">
                        <div className="sr-header__wordmark">
                            <LogoIcon />
                            Slinky Linky
                        </div>
                        <span className="sr-header__label">Supplier Partnership Portal</span>
                    </header>

                    {isResponded ? (
                        <main className="sr-main sr-main--centered">
                            <SrResponded status={lead.status} />
                        </main>
                    ) : (
                        <main className="sr-main">
                            <div className="sr-pane">
                                <div className="sr-offer">
                                    <div className="sr-offer__eyebrow">
                                        <span className="sr-chip sr-chip--blue">
                                            <span className="sr-chip--dot" />
                                            Partnership Invitation
                                        </span>
                                    </div>

                                    <h1 className="sr-offer__supplier">{lead.domain}</h1>

                                    <div className="sr-divider" />

                                    <div className="sr-offer__context">
                                        <p className="sr-offer__sub">
                                            We&apos;d love to have <strong>{lead.domain}</strong> as a
                                            Supplier on the Slinky Linky platform. As a Supplier, you
                                            receive paid article placement requests matching your
                                            site&apos;s niche — no cold outreach required.
                                        </p>
                                        {lead.price && (
                                            <p className="sr-offer__sub">
                                                Your listing shows a placement fee of{' '}
                                                <strong>{lead.currency}{lead.price}</strong>.
                                                You can adjust this when you join.
                                            </p>
                                        )}
                                        <p className="sr-offer__notice">
                                            If you represent other sites, you can upload a list below
                                            or share a Google Doc link — we&apos;d love to onboard
                                            your full portfolio.
                                        </p>
                                    </div>

                                    <div className="sr-divider" />

                                    <div className="sr-actions">
                                        <div className="sr-actions__secondary">
                                            <SrButton variant="danger"
                                                onClick={() => setShowDeclineModal(true)}>
                                                Decline
                                            </SrButton>
                                        </div>
                                        <div className="sr-actions__primary">
                                            <SrButton variant="accent"
                                                onClick={() => setShowAcceptModal(true)}>
                                                Join as Supplier →
                                            </SrButton>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Right pane: simple brand illustration */}
                            <div className="sr-hero-pane sr-hero-pane--simple">
                                <div className="lr-hero">
                                    <div className="lr-hero__icon">
                                        <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg" width="64" height="64">
                                            <circle cx="32" cy="32" r="30" stroke="rgba(99,102,241,0.3)" strokeWidth="1.5"/>
                                            <circle cx="32" cy="32" r="20" stroke="rgba(99,102,241,0.2)" strokeWidth="1"/>
                                            <path d="M32 12 L32 52M12 32 L52 32" stroke="rgba(99,102,241,0.15)" strokeWidth="1"/>
                                            <circle cx="32" cy="32" r="6" fill="rgba(99,102,241,0.6)"/>
                                            <circle cx="32" cy="12" r="3" fill="rgba(99,102,241,0.4)"/>
                                            <circle cx="32" cy="52" r="3" fill="rgba(99,102,241,0.4)"/>
                                            <circle cx="12" cy="32" r="3" fill="rgba(99,102,241,0.4)"/>
                                            <circle cx="52" cy="32" r="3" fill="rgba(99,102,241,0.4)"/>
                                        </svg>
                                    </div>
                                    <p className="lr-hero__headline">Grow with the network</p>
                                    <p className="lr-hero__sub">
                                        Join hundreds of publishers earning from quality
                                        content placements.
                                    </p>
                                </div>
                            </div>
                        </main>
                    )}

                    <footer className="sr-footer">
                        <span className="sr-footer__copy">© {new Date().getFullYear()} Slinky Linky™</span>
                        <div className="sr-footer__secure"><LockIcon />Secure invitation link</div>
                    </footer>

                    {showAcceptModal && (
                        <SrModal title="Join as Supplier" onClose={() => setShowAcceptModal(false)}>
                            <p className="sr-modal__agreement">
                                By accepting, you confirm you own or manage{' '}
                                <strong>{lead.domain}</strong> and agree to receive placement
                                requests through our platform.
                            </p>
                            <SrInput
                                label="Google Doc URL (optional)"
                                value={googleDocUrl}
                                onChange={setGoogleDocUrl}
                                placeholder="https://docs.google.com/…"
                            />
                            <div className="sr-input-group">
                                <label className="sr-label">
                                    Upload site list (optional — CSV, Excel, or text)
                                </label>
                                <input
                                    type="file"
                                    className="sr-file-input"
                                    accept=".csv,.xlsx,.xls,.txt,.pdf"
                                    onChange={e => setFile(e.target.files[0] ?? null)}
                                />
                                {file && (
                                    <p className="sr-file-name">{file.name}</p>
                                )}
                            </div>
                            {acceptError && <p className="sr-error">{acceptError}</p>}
                            <div className="sr-modal__actions">
                                <SrButton variant="ghost" onClick={() => setShowAcceptModal(false)}>
                                    Cancel
                                </SrButton>
                                <SrButton variant="accent" onClick={handleAccept} disabled={submitting}>
                                    {submitting ? 'Submitting…' : 'Confirm & Join'}
                                </SrButton>
                            </div>
                        </SrModal>
                    )}

                    {showDeclineModal && (
                        <SrModal title="Decline Invitation" onClose={() => setShowDeclineModal(false)}>
                            <p className="sr-modal__warning">
                                We&apos;ll mark this as declined and won&apos;t contact you about
                                this site again.
                            </p>
                            <SrInput
                                label="Reason (optional)"
                                value={declineReason}
                                onChange={setDeclineReason}
                                placeholder="Let us know why…"
                            />
                            <div className="sr-modal__actions">
                                <SrButton variant="ghost" onClick={() => setShowDeclineModal(false)}>
                                    Cancel
                                </SrButton>
                                <SrButton variant="danger" onClick={handleDecline} disabled={submitting}>
                                    {submitting ? 'Declining…' : 'Decline Invitation'}
                                </SrButton>
                            </div>
                        </SrModal>
                    )}
                </>
            )}
        </div>
    );
}
