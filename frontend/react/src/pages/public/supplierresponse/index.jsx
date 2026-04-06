import { useSearchParams } from "react-router-dom";
import { useEffect, useState } from "react";
import "./supplierresponse.css";

// ── Helpers ──────────────────────────────────────────────────────────────────
function formatDate(iso) {
  return new Date(iso).toLocaleDateString("en-GB", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}

// ── Network Graph Hero ────────────────────────────────────────────────────────
// Visualises the link-building transaction: Supplier domain ↔ Content link ↔ Network
// Pure inline SVG, no external assets.
function NetworkHero({ supplierName }) {
  const W = 540;
  const H = 460;

  // Truncate supplier name for display
  const displayName = supplierName
    ? supplierName.length > 20
      ? supplierName.slice(0, 18) + "…"
      : supplierName
    : "Your Domain";

  return (
    <svg
      viewBox={`0 0 ${W} ${H}`}
      xmlns="http://www.w3.org/2000/svg"
      width="100%"
      height="100%"
      preserveAspectRatio="xMidYMid slice"
      aria-hidden="true"
    >
      <defs>
        {/* Background gradient */}
        <linearGradient id="nh-bg" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%"   stopColor="#080E20" />
          <stop offset="100%" stopColor="#0C1526" />
        </linearGradient>

        {/* Dot grid pattern */}
        <pattern id="nh-dots" x="0" y="0" width="24" height="24" patternUnits="userSpaceOnUse">
          <circle cx="12" cy="12" r="0.8" fill="rgba(148,163,184,0.18)" />
        </pattern>

        {/* Node glow — blue */}
        <radialGradient id="nh-glow-b" cx="50%" cy="50%" r="50%">
          <stop offset="0%"   stopColor="#3B82F6" stopOpacity="0.35" />
          <stop offset="100%" stopColor="#3B82F6" stopOpacity="0" />
        </radialGradient>

        {/* Node glow — emerald */}
        <radialGradient id="nh-glow-e" cx="50%" cy="50%" r="50%">
          <stop offset="0%"   stopColor="#059669" stopOpacity="0.3" />
          <stop offset="100%" stopColor="#059669" stopOpacity="0" />
        </radialGradient>

        {/* Central node glow */}
        <radialGradient id="nh-glow-c" cx="50%" cy="50%" r="50%">
          <stop offset="0%"   stopColor="#6366F1" stopOpacity="0.4" />
          <stop offset="100%" stopColor="#6366F1" stopOpacity="0" />
        </radialGradient>

        {/* Connection line gradient */}
        <linearGradient id="nh-link-grad" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0%"   stopColor="#059669" />
          <stop offset="50%"  stopColor="#6366F1" />
          <stop offset="100%" stopColor="#3B82F6" />
        </linearGradient>

        {/* Clip for nodes */}
        <clipPath id="nh-clip-supplier">
          <circle cx="150" cy="220" r="56" />
        </clipPath>
        <clipPath id="nh-clip-content">
          <circle cx="390" cy="220" r="46" />
        </clipPath>

        {/* Animated dashes filter */}
        <filter id="nh-blur-sm">
          <feGaussianBlur stdDeviation="1.5" />
        </filter>
      </defs>

      {/* Background */}
      <rect width={W} height={H} fill="url(#nh-bg)" />
      <rect width={W} height={H} fill="url(#nh-dots)" />

      {/* ── Peripheral mini-nodes (SEO network context) ────────────────── */}
      {/* Small nodes floating around — represent the SEO network */}
      {[
        { cx: 60,  cy: 80,  r: 5,  color: "rgba(59,130,246,0.4)"  },
        { cx: 120, cy: 55,  r: 3.5, color: "rgba(99,102,241,0.35)" },
        { cx: 55,  cy: 360, r: 4,  color: "rgba(59,130,246,0.35)" },
        { cx: 90,  cy: 310, r: 3,  color: "rgba(99,102,241,0.3)"  },
        { cx: 480, cy: 75,  r: 4.5, color: "rgba(5,150,105,0.4)"  },
        { cx: 490, cy: 360, r: 3.5, color: "rgba(5,150,105,0.35)" },
        { cx: 450, cy: 390, r: 3,  color: "rgba(99,102,241,0.3)"  },
        { cx: 290, cy: 40,  r: 3,  color: "rgba(99,102,241,0.3)"  },
      ].map((n, i) => (
        <circle key={i} cx={n.cx} cy={n.cy} r={n.r} fill={n.color} />
      ))}

      {/* Thin connecting lines from peripheral nodes to main nodes */}
      <g stroke="rgba(148,163,184,0.08)" strokeWidth="0.8">
        <line x1="60"  y1="80"  x2="150" y2="220" />
        <line x1="120" y1="55"  x2="150" y2="220" />
        <line x1="55"  y1="360" x2="150" y2="220" />
        <line x1="90"  y1="310" x2="150" y2="220" />
        <line x1="480" y1="75"  x2="390" y2="220" />
        <line x1="490" y1="360" x2="390" y2="220" />
        <line x1="450" y1="390" x2="390" y2="220" />
        <line x1="290" y1="40"  x2="270" y2="220" />
      </g>

      {/* ── Main connection: Supplier → Link → Content ─────────────────── */}

      {/* Connection glow track */}
      <line
        x1="206" y1="220" x2="344" y2="220"
        stroke="rgba(99,102,241,0.15)"
        strokeWidth="8"
        filter="url(#nh-blur-sm)"
      />

      {/* Connection line */}
      <line
        x1="206" y1="220" x2="344" y2="220"
        stroke="url(#nh-link-grad)"
        strokeWidth="2"
        strokeDasharray="6 4"
      >
        <animate
          attributeName="stroke-dashoffset"
          from="0"
          to="-40"
          dur="1.5s"
          repeatCount="indefinite"
        />
      </line>

      {/* Animated flow particle on connection */}
      <circle r="3.5" fill="#6366F1" opacity="0.9">
        <animateMotion
          path="M 206 220 L 344 220"
          dur="1.8s"
          repeatCount="indefinite"
          keyPoints="0;1"
          keyTimes="0;1"
          calcMode="linear"
        />
        <animate
          attributeName="opacity"
          values="0;1;1;0"
          keyTimes="0;0.1;0.9;1"
          dur="1.8s"
          repeatCount="indefinite"
        />
      </circle>

      {/* ── Link badge (center of connection) ─────────────────────────── */}
      <rect
        x="232" y="207"
        width="76" height="26"
        rx="13"
        fill="#0C1526"
        stroke="rgba(99,102,241,0.45)"
        strokeWidth="1"
      />
      <text
        x="270" y="225"
        textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace"
        fontSize="8"
        fontWeight="600"
        letterSpacing="1.5"
        fill="#818CF8"
      >
        DO-FOLLOW
      </text>

      {/* ── Supplier node (left) ───────────────────────────────────────── */}

      {/* Outer pulse ring */}
      <circle cx="150" cy="220" r="72" fill="none" stroke="rgba(5,150,105,0.15)" strokeWidth="1">
        <animate attributeName="r" values="72;80;72" dur="3s" repeatCount="indefinite" />
        <animate attributeName="stroke-opacity" values="0.15;0.05;0.15" dur="3s" repeatCount="indefinite" />
      </circle>

      {/* Glow */}
      <ellipse cx="150" cy="220" rx="90" ry="90" fill="url(#nh-glow-e)" />

      {/* Node ring */}
      <circle cx="150" cy="220" r="56" fill="#0C1526" stroke="#059669" strokeWidth="1.5" />

      {/* Inner accent ring */}
      <circle cx="150" cy="220" r="44" fill="rgba(5,150,105,0.06)" stroke="rgba(5,150,105,0.2)" strokeWidth="1" />

      {/* Link-chain icon (represents "your domain") */}
      <g transform="translate(138, 204)">
        {/* Simple chain-link icon made from two rounded rectangles */}
        <rect x="0" y="4" width="12" height="8" rx="4" fill="none" stroke="#059669" strokeWidth="1.8" />
        <rect x="8" y="4" width="12" height="8" rx="4" fill="none" stroke="#059669" strokeWidth="1.8" />
        {/* Overlap fill to create chain effect */}
        <rect x="8" y="6" width="4" height="4" fill="#0C1526" />
      </g>

      {/* Node label */}
      <text
        x="150" y="248"
        textAnchor="middle"
        fontFamily="'Plus Jakarta Sans', sans-serif"
        fontSize="9"
        fontWeight="700"
        letterSpacing="0.5"
        fill="#34D399"
        opacity="0.9"
      >
        {displayName.toUpperCase().slice(0, 12)}
      </text>

      {/* "YOUR DOMAIN" sub-label */}
      <text
        x="150" y="280"
        textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace"
        fontSize="7.5"
        letterSpacing="1.5"
        fill="rgba(148,163,184,0.5)"
      >
        YOUR DOMAIN
      </text>

      {/* ── Content/Link node (right) ──────────────────────────────────── */}

      {/* Outer pulse ring */}
      <circle cx="390" cy="220" r="60" fill="none" stroke="rgba(59,130,246,0.12)" strokeWidth="1">
        <animate attributeName="r" values="60;68;60" dur="3.5s" repeatCount="indefinite" />
        <animate attributeName="stroke-opacity" values="0.12;0.04;0.12" dur="3.5s" repeatCount="indefinite" />
      </circle>

      {/* Glow */}
      <ellipse cx="390" cy="220" rx="75" ry="75" fill="url(#nh-glow-b)" />

      {/* Node ring */}
      <circle cx="390" cy="220" r="46" fill="#0C1526" stroke="#3B82F6" strokeWidth="1.5" />

      {/* Inner accent ring */}
      <circle cx="390" cy="220" r="36" fill="rgba(59,130,246,0.06)" stroke="rgba(59,130,246,0.2)" strokeWidth="1" />

      {/* Anchor icon (represents placed link) */}
      <g transform="translate(379, 206)">
        {/* Simple anchor: vertical line + horizontal bar + circle top */}
        <circle cx="11" cy="4" r="3.5" fill="none" stroke="#3B82F6" strokeWidth="1.6" />
        <line x1="11" y1="7.5" x2="11" y2="20" stroke="#3B82F6" strokeWidth="1.6" />
        <line x1="5" y1="11" x2="17" y2="11" stroke="#3B82F6" strokeWidth="1.4" />
        <path d="M5 20 Q11 17 17 20" fill="none" stroke="#3B82F6" strokeWidth="1.4" />
      </g>

      {/* Node label */}
      <text
        x="390" y="240"
        textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace"
        fontSize="7.5"
        letterSpacing="1.5"
        fill="rgba(148,163,184,0.5)"
      >
        PAID LINK
      </text>

      {/* ── Metric chips floating around nodes ────────────────────────── */}

      {/* Chip: Permanent */}
      <rect x="54" y="128" width="62" height="20" rx="5"
        fill="rgba(12,21,38,0.95)" stroke="rgba(5,150,105,0.35)" strokeWidth="0.8" />
      <text x="85" y="142" textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace" fontSize="7" letterSpacing="0.8"
        fill="#34D399" opacity="0.8">PERMANENT</text>
      <line x1="116" y1="138" x2="136" y2="180" stroke="rgba(5,150,105,0.2)" strokeWidth="0.8" strokeDasharray="3 3" />

      {/* Chip: Do-Follow */}
      <rect x="40" y="285" width="58" height="20" rx="5"
        fill="rgba(12,21,38,0.95)" stroke="rgba(99,102,241,0.35)" strokeWidth="0.8" />
      <text x="69" y="299" textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace" fontSize="7" letterSpacing="0.8"
        fill="#818CF8" opacity="0.8">VERIFIED</text>
      <line x1="98" y1="295" x2="130" y2="255" stroke="rgba(99,102,241,0.2)" strokeWidth="0.8" strokeDasharray="3 3" />

      {/* Chip: SEO Value */}
      <rect x="414" y="128" width="66" height="20" rx="5"
        fill="rgba(12,21,38,0.95)" stroke="rgba(59,130,246,0.35)" strokeWidth="0.8" />
      <text x="447" y="142" textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace" fontSize="7" letterSpacing="0.8"
        fill="#60A5FA" opacity="0.8">SEO VALUE</text>
      <line x1="414" y1="138" x2="400" y2="178" stroke="rgba(59,130,246,0.2)" strokeWidth="0.8" strokeDasharray="3 3" />

      {/* Chip: Indexed */}
      <rect x="420" y="290" width="54" height="20" rx="5"
        fill="rgba(12,21,38,0.95)" stroke="rgba(59,130,246,0.3)" strokeWidth="0.8" />
      <text x="447" y="304" textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace" fontSize="7" letterSpacing="0.8"
        fill="#60A5FA" opacity="0.7">INDEXED</text>
      <line x1="420" y1="300" x2="406" y2="258" stroke="rgba(59,130,246,0.18)" strokeWidth="0.8" strokeDasharray="3 3" />

      {/* ── Bottom label ──────────────────────────────────────────────── */}
      <text
        x={W / 2} y={H - 22}
        textAnchor="middle"
        fontFamily="'JetBrains Mono', monospace"
        fontSize="8.5"
        letterSpacing="3"
        fill="rgba(148,163,184,0.25)"
      >
        BLOGGER OUTREACH NETWORK
      </text>
    </svg>
  );
}

// ── Local primitives ──────────────────────────────────────────────────────────
function SrButton({ children, onClick, variant = "accent", disabled = false }) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className={`sr-btn sr-btn--${variant}`}
    >
      {children}
    </button>
  );
}

function SrInput({ label, value, onChange, placeholder = "" }) {
  return (
    <div className="sr-input-group">
      <label className="sr-label">{label}</label>
      <input
        className="sr-input"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
      />
    </div>
  );
}

function SrModal({ children, onClose, title, wide = false }) {
  const handleOverlay = (e) => {
    if (e.target === e.currentTarget) onClose();
  };
  return (
    <div className="sr-modal-overlay" onClick={handleOverlay}>
      <div className={`sr-modal${wide ? " sr-modal--wide" : ""}`}>
        <div className="sr-modal-header">
          <span className="sr-modal-title">{title}</span>
          <button className="sr-modal-close" onClick={onClose} aria-label="Close">✕</button>
        </div>
        <div className="sr-modal-body">{children}</div>
      </div>
    </div>
  );
}

// ── Loading ───────────────────────────────────────────────────────────────────
function SrLoading() {
  return (
    <div className="sr-loading">
      <div className="sr-loading__ring" />
      <p className="sr-loading__text">Loading your offer</p>
    </div>
  );
}

// ── 404 ───────────────────────────────────────────────────────────────────────
function SrNotFound() {
  return (
    <div className="sr-notfound">
      <span className="sr-notfound__code">404</span>
      <p className="sr-notfound__msg">This offer link is invalid or has expired.</p>
    </div>
  );
}

// ── Already responded ─────────────────────────────────────────────────────────
function SrResponded({ status }) {
  const accepted = status !== "DECLINED";
  return (
    <div className={`sr-responded sr-responded--${accepted ? "accepted" : "declined"}`}>
      <div className="sr-responded__tag">
        {accepted ? "✓  Offer Accepted" : "Offer Declined"}
      </div>
      <h1 className="sr-responded__headline">
        {accepted ? "It's a deal." : "Understood."}
      </h1>
      <p className="sr-responded__sub">
        {accepted
          ? "Thank you for accepting. We'll be in touch soon to confirm everything."
          : "Sorry to see you go. Thanks for letting us know."}
      </p>
    </div>
  );
}

// ── Logo icon ─────────────────────────────────────────────────────────────────
function LogoIcon() {
  return (
    <div className="sr-header__icon">
      <svg viewBox="0 0 14 14" fill="none" width="10" height="10">
        <path d="M3 7 C3 4.8 4.8 3 7 3 S11 4.8 11 7 9.2 11 7 11" stroke="white" strokeWidth="1.8" strokeLinecap="round"/>
        <circle cx="3" cy="11" r="1.5" fill="white" opacity="0.7"/>
      </svg>
    </div>
  );
}

// ── Lock icon ─────────────────────────────────────────────────────────────────
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
export default function SupplierResponse() {
  const [searchParams] = useSearchParams();

  const [guidError, setGuidError]               = useState(null);
  const [acceptError, setAcceptError]           = useState(null);
  const [engagement, setEngagement]             = useState(null);
  const [showAcceptModal, setShowAcceptModal]   = useState(false);
  const [showDeclineModal, setShowDeclineModal] = useState(false);
  const [showPreviewModal, setShowPreviewModal] = useState(false);
  const [blogTitle, setBlogTitle]   = useState("");
  const [blogUrl, setBlogUrl]       = useState("");
  const [invoiceUrl, setInvoiceUrl] = useState("");
  const [declineReason, setDeclineReason] = useState("");
  const [doNotContact, setDoNotContact]   = useState(false);
  const [isDeclining, setIsDeclining]     = useState(false);

  useEffect(() => {
    document.body.style.backgroundColor = "#060B18";
    document.title = "Slinky Linky | Supplier Offer";
    return () => { document.body.style.backgroundColor = ""; };
  }, []);

  useEffect(() => {
    const id = searchParams.get("id");
    if (id) {
      fetch("/.rest/engagements/search/findByGuid?guid=" + id)
        .then((res) => res.json())
        .then((e) => setEngagement(e))
        .catch((err) => setGuidError(err));
    }
  }, [searchParams]);

  const handleAccept = () => {
    setAcceptError(null);
    const id = searchParams.get("id");
    fetch("/.rest/engagements/accept?guid=" + id, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ blogTitle, blogUrl, invoiceUrl }),
    })
      .then((res) => {
        if (res.ok) { setShowAcceptModal(false); window.location.reload(); }
        else throw new Error("Accept failed");
      })
      .catch((err) => { console.error(err); setAcceptError(err); });
  };

  const handleDecline = () => {
    setIsDeclining(true);
    const id = searchParams.get("id");
    fetch("/.rest/engagements/decline?guid=" + id, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ declinedReason: declineReason, doNotContact }),
    })
      .then((res) => { if (res.ok) window.location.reload(); })
      .catch((err) => { console.error(err); setIsDeclining(false); });
  };

  const isResponded = engagement?.status !== "NEW";

  return (
    <div className="sr-root">
      {guidError && <SrNotFound />}
      {!engagement && !guidError && <SrLoading />}

      {engagement && (
        <>
          {/* ── Header ──────────────────────────────────────────────────── */}
          <header className="sr-header">
            <div className="sr-header__wordmark">
              <LogoIcon />
              Slinky Linky
            </div>
            <span className="sr-header__label">Blogger Outreach Portal</span>
          </header>

          {/* ── Main ────────────────────────────────────────────────────── */}
          {isResponded ? (
            <main className="sr-main sr-main--centered">
              <SrResponded status={engagement.status} />
            </main>
          ) : (
            <main className="sr-main">
              {/* Left: offer content */}
              <div className="sr-pane">
                <div className="sr-offer">
                  {/* Eyebrow */}
                  <div className="sr-offer__eyebrow">
                    <span className="sr-chip sr-chip--blue">
                      <span className="sr-chip--dot" />
                      New Offer
                    </span>
                    <span className="sr-offer__id">#{engagement.proposalId}</span>
                  </div>

                  {/* Supplier name */}
                  <h1 className="sr-offer__supplier">{engagement.supplierName}</h1>

                  {/* Divider */}
                  <div className="sr-divider" />

                  {/* Price */}
                  <div className="sr-price-block">
                    <p className="sr-price-label">Offer Amount</p>
                    <div className="sr-price">
                      <span className="sr-price__currency">
                        {engagement.supplierWeWriteFeeCurrency}
                      </span>
                      <span className="sr-price__amount">
                        {engagement.supplierWeWriteFee}
                      </span>
                    </div>
                  </div>

                  {/* Context */}
                  <div className="sr-offer__context">
                    <p className="sr-offer__sub">
                      For hosting the article we sent to{" "}
                      <span className="sr-offer__email">{engagement.supplierEmail}</span>{" "}
                      on {formatDate(engagement.supplierEmailSent)}.
                    </p>
                    <p className="sr-offer__notice">
                      If the article isn&apos;t yet live or the invoice
                      isn&apos;t yet raised, close this tab and return when
                      you&apos;re ready.
                    </p>
                  </div>

                  {/* Divider */}
                  <div className="sr-divider" />

                  {/* Actions */}
                  <div className="sr-actions">
                    <div className="sr-actions__secondary">
                      <SrButton variant="ghost" onClick={() => setShowPreviewModal(true)}>
                        Preview Article
                      </SrButton>
                      <SrButton variant="danger" onClick={() => setShowDeclineModal(true)}>
                        Decline
                      </SrButton>
                    </div>
                    <div className="sr-actions__primary">
                      <SrButton variant="accent" onClick={() => setShowAcceptModal(true)}>
                        Accept Offer →
                      </SrButton>
                    </div>
                  </div>
                </div>
              </div>

              {/* Right: network graph hero */}
              <div className="sr-hero-pane">
                <NetworkHero supplierName={engagement.supplierName} />
              </div>
            </main>
          )}

          {/* ── Footer ──────────────────────────────────────────────────── */}
          <footer className="sr-footer">
            <span className="sr-footer__copy">© {new Date().getFullYear()} Slinky Linky™</span>
            <div className="sr-footer__secure"><LockIcon />Secure offer link</div>
          </footer>

          {/* ── Accept modal ────────────────────────────────────────────── */}
          {showAcceptModal && (
            <SrModal title="Confirm Acceptance" onClose={() => setShowAcceptModal(false)}>
              <p className="sr-modal__agreement">
                By accepting, you confirm the article is live on your site and
                contains <strong>permanent, do-follow links</strong> as agreed.
              </p>
              <SrInput label="Article title" value={blogTitle} onChange={setBlogTitle}
                placeholder="Your article heading…" />
              <SrInput label="URL to live article" value={blogUrl} onChange={setBlogUrl}
                placeholder="https://…" />
              <SrInput label="URL to your invoice" value={invoiceUrl} onChange={setInvoiceUrl}
                placeholder="https://…" />
              {acceptError && (
                <p className="sr-error">Server error — duplicate article URL or invoice URL?</p>
              )}
              <div className="sr-modal__actions">
                <SrButton variant="ghost" onClick={() => setShowAcceptModal(false)}>Cancel</SrButton>
                <SrButton variant="accent" onClick={handleAccept}
                  disabled={!blogTitle || !blogUrl || !invoiceUrl}>
                  Confirm &amp; Accept
                </SrButton>
              </div>
            </SrModal>
          )}

          {/* ── Decline modal ───────────────────────────────────────────── */}
          {showDeclineModal && (
            <SrModal title="Decline Offer" onClose={() => setShowDeclineModal(false)}>
              <p className="sr-modal__warning">Once declined, this offer cannot be reinstated.</p>
              <SrInput label="Reason (optional)" value={declineReason} onChange={setDeclineReason}
                placeholder="Let us know why…" />
              <label className="sr-checkbox-row">
                <input type="checkbox" checked={doNotContact}
                  onChange={(e) => setDoNotContact(e.target.checked)} />
                <span>Remove me from all future offers</span>
              </label>
              {doNotContact && (
                <p className="sr-modal__info">
                  You&apos;ll receive one final confirmation email, then no further contact.
                </p>
              )}
              <div className="sr-modal__actions">
                <SrButton variant="ghost" onClick={() => setShowDeclineModal(false)}>Cancel</SrButton>
                <SrButton variant="danger" onClick={handleDecline} disabled={isDeclining}>
                  {isDeclining ? "Declining…" : "Decline Offer"}
                </SrButton>
              </div>
            </SrModal>
          )}

          {/* ── Article preview modal ───────────────────────────────────── */}
          {showPreviewModal && (
            <SrModal title="Article Preview" onClose={() => setShowPreviewModal(false)} wide>
              <div className="sr-preview">
                <iframe
                  src={"/.rest/proposalsupport/getArticleFormatted?proposalId=" + engagement.proposalId}
                  width="100%" height={520} title="Article preview"
                />
              </div>
            </SrModal>
          )}
        </>
      )}
    </div>
  );
}
