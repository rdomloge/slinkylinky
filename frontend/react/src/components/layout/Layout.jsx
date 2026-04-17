import React, { useEffect, useState, useRef } from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import { useAuth } from '@/auth/AuthProvider';
import TenantBadge from '../TenantBadge';
import Logo from '@/assets/logo.png';

const ENTITY_CHIPS = [
    { label: 'Suppliers', bg: 'rgba(109, 184, 157, 0.12)', color: '#6db89d', border: 'rgba(109, 184, 157, 0.3)' },
    { label: 'Demand', bg: 'rgba(212, 165, 116, 0.12)', color: '#d4a574', border: 'rgba(212, 165, 116, 0.3)' },
    { label: 'Sites', bg: 'rgba(168, 157, 189, 0.12)', color: '#a89dbd', border: 'rgba(168, 157, 189, 0.3)' },
];

// SVG Connection nodes for login background
const ConnectionNodes = () => (
    <svg
        style={{
            position: 'absolute',
            inset: 0,
            width: '100%',
            height: '100%',
            pointerEvents: 'none',
        }}
        viewBox="0 0 1200 800"
        preserveAspectRatio="xMidYMid slice"
    >
        <defs>
            <linearGradient id="nodeGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stopColor="rgba(109, 184, 157, 0.4)" />
                <stop offset="100%" stopColor="rgba(212, 165, 116, 0.3)" />
            </linearGradient>
        </defs>

        {/* Subtle connecting lines */}
        <g opacity="0.15" stroke="url(#nodeGradient)" strokeWidth="0.5">
            <line x1="100" y1="100" x2="400" y2="300" />
            <line x1="400" y1="300" x2="800" y2="200" />
            <line x1="800" y1="200" x2="1000" y2="500" />
            <line x1="1000" y1="500" x2="600" y2="700" />
            <line x1="600" y1="700" x2="200" y2="600" />
            <line x1="200" y1="600" x2="100" y2="100" />
            <line x1="400" y1="300" x2="600" y2="700" />
            <line x1="800" y1="200" x2="200" y2="600" />
        </g>

        {/* Connection nodes */}
        <g fill="rgba(109, 184, 157, 0.5)">
            <circle cx="100" cy="100" r="2.5" />
            <circle cx="400" cy="300" r="2" />
            <circle cx="800" cy="200" r="2.5" />
            <circle cx="1000" cy="500" r="2" />
            <circle cx="600" cy="700" r="2" />
            <circle cx="200" cy="600" r="2.5" />
        </g>
    </svg>
);

export default function Layout({ children, pagetitle = ' ', headerTitle, headerActions }) {
    const { user, isAuthenticated, isLoading, signIn } = useAuth();
    const [launching, setLaunching] = useState(false);
    const [launchOrigin, setLaunchOrigin] = useState({ x: '50%', y: '50%' });
    const [entered, setEntered] = useState(false);
    const buttonRef = useRef(null);
    const overlayRef = useRef(null);

    useEffect(() => {
        if (pagetitle) document.title = 'SlinkyLinky | ' + pagetitle;
    }, [pagetitle]);

    useEffect(() => {
        if (isAuthenticated && user) {
            if (sessionStorage.getItem('sl_just_authenticated')) {
                sessionStorage.removeItem('sl_just_authenticated');
                setEntered(true);
                const t = setTimeout(() => setEntered(false), 800);
                return () => clearTimeout(t);
            }
        }
    }, [isAuthenticated, user]);

    useEffect(() => {
        if (launching && overlayRef.current) {
            const timer = setTimeout(() => {
                if (overlayRef.current) {
                    overlayRef.current.style.clipPath =
                        `circle(200vmax at ${launchOrigin.x} ${launchOrigin.y})`;
                }
            }, 30);
            return () => clearTimeout(timer);
        }
    }, [launching, launchOrigin]);

    const handleSignIn = () => {
        if (buttonRef.current) {
            const r = buttonRef.current.getBoundingClientRect();
            setLaunchOrigin({ x: `${r.left + r.width / 2}px`, y: `${r.top + r.height / 2}px` });
        }
        setLaunching(true);
        setTimeout(() => signIn(), 750);
    };

    /* ── Authenticated ─────────────────────────────────────────────────────── */
    if (isAuthenticated && user) {
        return (
            <div
                className="flex flex-col h-screen"
                style={entered ? { animation: 'sl-entry-reveal 0.5s ease-out both' } : undefined}
            >
                <div className="flex flex-1 overflow-hidden">
                    <aside
                        className="w-56 shrink-0 flex flex-col border-r overflow-y-auto"
                        style={{
                            background: 'linear-gradient(180deg, #ffffff 0%, #fafbfc 100%)',
                            borderRightColor: 'var(--border-light)',
                        }}
                    >
                        <TenantBadge />
                        <a
                            href="/"
                            className="flex items-center gap-3 px-4 py-[1.1rem] shrink-0 hover:bg-gray-50 transition-colors group"
                            style={{ borderBottomColor: 'var(--border-light)', borderBottomWidth: '1px' }}
                        >
                            <img
                                src={Logo}
                                width={Math.round(439 / 10)}
                                height={Math.round(498 / 10)}
                                alt="Logo"
                                className="opacity-70 group-hover:opacity-90 transition-opacity"
                            />
                            <span
                                className="font-bold text-base"
                                style={{
                                    fontFamily: "'Space Grotesk', sans-serif",
                                    letterSpacing: '-0.03em',
                                    color: 'var(--text-primary)',
                                }}
                            >
                                Slinky<span style={{ color: '#a89dbd' }}>Linky</span>
                            </span>
                        </a>
                        <Menu />
                    </aside>
                    <div className="flex flex-col flex-1 min-w-0" style={{ background: 'var(--bg-primary)' }}>
                        <Header title={headerTitle ?? pagetitle} actions={headerActions} />
                        <div className="flex-1 overflow-y-auto pt-4">
                            {children}
                            <Footer />
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    /* ── Loading ───────────────────────────────────────────────────────────── */
    if (isLoading) {
        return (
            <div
                style={{
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                    height: '100vh',
                    background: 'linear-gradient(135deg, #fafbfc 0%, #f5f5f5 100%)',
                }}
            >
                <div
                    style={{
                        position: 'relative',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                    }}
                >
                    <img
                        src={Logo}
                        width={44}
                        height={50}
                        alt="SlinkyLinky"
                        style={{
                            opacity: 0.6,
                            animation: 'sl-callback-breathe 2s ease-in-out infinite',
                            filter: 'saturate(0.8)',
                        }}
                    />
                    <div
                        style={{
                            position: 'absolute',
                            width: 80,
                            height: 80,
                            borderRadius: '50%',
                            border: '1px solid rgba(109, 184, 157, 0.3)',
                            animation: 'sl-ping-ring 2s ease-out infinite',
                        }}
                    />
                </div>
            </div>
        );
    }

    /* ── Unauthenticated (login page) ──────────────────────────────────────── */
    return (
        <>
            {/* Portal overlay — expands from button on sign-in click */}
            {launching && (
                <div
                    ref={overlayRef}
                    style={{
                        position: 'fixed',
                        inset: 0,
                        zIndex: 200,
                        background: 'linear-gradient(135deg, #a89dbd 0%, #8dcbb3 100%)',
                        clipPath: `circle(4px at ${launchOrigin.x} ${launchOrigin.y})`,
                        transition: 'clip-path 0.65s cubic-bezier(0.4, 0, 0.2, 1)',
                        willChange: 'clip-path',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                    }}
                >
                    <img
                        src={Logo}
                        width={44}
                        height={50}
                        alt="SlinkyLinky"
                        style={{
                            animation: 'sl-fade-up 0.3s ease-out 0.4s both',
                            opacity: 0.9,
                        }}
                    />
                </div>
            )}

            <div
                style={{
                    position: 'fixed',
                    inset: 0,
                    background: 'linear-gradient(135deg, #fafbfc 0%, #f5f5f5 50%, #efefef 100%)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    overflow: 'hidden',
                    fontFamily: "'Space Grotesk', sans-serif",
                }}
            >
                {/* Connection network background */}
                <ConnectionNodes />

                {/* Soft ambient nodes */}
                <div
                    style={{
                        position: 'absolute',
                        top: '10%',
                        left: '8%',
                        width: 500,
                        height: 500,
                        background:
                            'radial-gradient(circle, rgba(109, 184, 157, 0.12) 0%, transparent 70%)',
                        borderRadius: '50%',
                        filter: 'blur(60px)',
                        animation: 'sl-node-drift-a 22s ease-in-out infinite',
                        pointerEvents: 'none',
                    }}
                />
                <div
                    style={{
                        position: 'absolute',
                        bottom: '12%',
                        right: '10%',
                        width: 450,
                        height: 450,
                        background:
                            'radial-gradient(circle, rgba(212, 165, 116, 0.08) 0%, transparent 70%)',
                        borderRadius: '50%',
                        filter: 'blur(56px)',
                        animation: 'sl-node-drift-b 26s ease-in-out infinite',
                        pointerEvents: 'none',
                    }}
                />
                <div
                    style={{
                        position: 'absolute',
                        top: '45%',
                        right: '8%',
                        width: 380,
                        height: 380,
                        background:
                            'radial-gradient(circle, rgba(168, 157, 189, 0.1) 0%, transparent 70%)',
                        borderRadius: '50%',
                        filter: 'blur(50px)',
                        animation: 'sl-node-drift-c 20s ease-in-out infinite',
                        pointerEvents: 'none',
                    }}
                />

                {/* Fine dot grid */}
                <div
                    style={{
                        position: 'absolute',
                        inset: 0,
                        backgroundImage:
                            'radial-gradient(circle, rgba(0,0,0,0.04) 0.5px, transparent 0.5px)',
                        backgroundSize: '40px 40px',
                        pointerEvents: 'none',
                    }}
                />

                {/* Main content */}
                <div
                    style={{
                        position: 'relative',
                        zIndex: 10,
                        textAlign: 'center',
                        maxWidth: 420,
                        width: '100%',
                        padding: '0 2rem',
                    }}
                >
                    {/* Logo + wordmark */}
                    <div
                        style={{
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            gap: 14,
                            marginBottom: 48,
                            animation: 'sl-fade-up 0.55s ease-out 0.1s both',
                        }}
                    >
                        <img
                            src={Logo}
                            width={Math.round(439 / 8)}
                            height={Math.round(498 / 8)}
                            alt="SlinkyLinky"
                            style={{ opacity: 0.75 }}
                        />
                        <span
                            style={{
                                fontSize: '1.8rem',
                                fontWeight: 700,
                                color: 'var(--text-primary)',
                                letterSpacing: '-0.02em',
                                lineHeight: 1,
                            }}
                        >
                            Slinky<span style={{ color: '#a89dbd' }}>Linky</span>
                        </span>
                    </div>

                    {/* Headline */}
                    <h1
                        style={{
                            fontSize: '2.75rem',
                            fontWeight: 800,
                            color: 'var(--text-primary)',
                            letterSpacing: '-0.045em',
                            lineHeight: 1.1,
                            margin: '0 0 16px',
                            animation: 'sl-fade-up 0.55s ease-out 0.15s both',
                        }}
                    >
                        Links,<br />
                        <span style={{ color: '#a89dbd' }}>connected.</span>
                    </h1>

                    {/* Subheading */}
                    <p
                        style={{
                            color: 'var(--text-secondary)',
                            fontSize: '1rem',
                            lineHeight: 1.6,
                            margin: '0 0 44px',
                            animation: 'sl-fade-up 0.55s ease-out 0.25s both',
                            fontWeight: 400,
                        }}
                    >
                        Connect demand with supply. Intelligence for SEO teams.
                    </p>

                    {/* Entity chips */}
                    <div
                        style={{
                            display: 'flex',
                            justifyContent: 'center',
                            gap: 10,
                            marginBottom: 48,
                            animation: 'sl-fade-up 0.55s ease-out 0.35s both',
                            flexWrap: 'wrap',
                        }}
                    >
                        {ENTITY_CHIPS.map(({ label, bg, color, border }) => (
                            <span
                                key={label}
                                style={{
                                    fontFamily: "'DM Mono', monospace",
                                    fontSize: '0.65rem',
                                    fontWeight: 600,
                                    letterSpacing: '0.12em',
                                    textTransform: 'uppercase',
                                    padding: '0.45em 0.95em',
                                    borderRadius: 999,
                                    background: bg,
                                    color,
                                    border: `1px solid ${border}`,
                                }}
                            >
                                {label}
                            </span>
                        ))}
                    </div>

                    {/* Sign-in button */}
                    <div style={{ animation: 'sl-fade-up 0.55s ease-out 0.45s both' }}>
                        <button
                            ref={buttonRef}
                            onClick={handleSignIn}
                            disabled={launching}
                            style={{
                                width: '100%',
                                padding: '1rem 2.2rem',
                                background: 'linear-gradient(135deg, #a89dbd 0%, #8dcbb3 100%)',
                                color: 'white',
                                fontFamily: "'Space Grotesk', sans-serif",
                                fontWeight: 600,
                                fontSize: '1rem',
                                letterSpacing: '-0.01em',
                                border: 'none',
                                borderRadius: 12,
                                cursor: launching ? 'default' : 'pointer',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                gap: 10,
                                boxShadow: '0 4px 16px rgba(168, 157, 189, 0.25)',
                                transition: 'box-shadow 0.3s ease, transform 0.2s ease',
                                position: 'relative',
                                overflow: 'hidden',
                            }}
                            onMouseEnter={(e) => {
                                if (!launching) {
                                    e.currentTarget.style.boxShadow =
                                        '0 8px 28px rgba(168, 157, 189, 0.35)';
                                    e.currentTarget.style.transform = 'translateY(-1px)';
                                }
                            }}
                            onMouseLeave={(e) => {
                                if (!launching) {
                                    e.currentTarget.style.boxShadow =
                                        '0 4px 16px rgba(168, 157, 189, 0.25)';
                                    e.currentTarget.style.transform = 'translateY(0)';
                                }
                            }}
                        >
                            {/* Shimmer layer */}
                            <span
                                style={{
                                    position: 'absolute',
                                    inset: 0,
                                    background:
                                        'linear-gradient(105deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%)',
                                }}
                            />
                            {launching ? (
                                <span
                                    style={{
                                        display: 'flex',
                                        gap: 6,
                                        alignItems: 'center',
                                        position: 'relative',
                                    }}
                                >
                                    {[0, 160, 320].map((d) => (
                                        <span
                                            key={d}
                                            style={{
                                                width: 6,
                                                height: 6,
                                                borderRadius: '50%',
                                                background: 'rgba(255,255,255,0.9)',
                                                animation:
                                                    'sl-loading-dot 1.1s ease-in-out infinite',
                                                animationDelay: `${d}ms`,
                                            }}
                                        />
                                    ))}
                                </span>
                            ) : (
                                <>
                                    <span style={{ position: 'relative' }}>
                                        Sign in with SSO
                                    </span>
                                    <svg
                                        width="16"
                                        height="16"
                                        viewBox="0 0 16 16"
                                        fill="none"
                                        style={{ position: 'relative' }}
                                    >
                                        <path
                                            d="M2 8h12M11 4l4 4-4 4"
                                            stroke="currentColor"
                                            strokeWidth="1.5"
                                            strokeLinecap="round"
                                            strokeLinejoin="round"
                                        />
                                    </svg>
                                </>
                            )}
                        </button>
                    </div>

                    {/* Footer text */}
                    <p
                        style={{
                            fontSize: '0.75rem',
                            color: 'var(--text-secondary)',
                            marginTop: 28,
                            animation: 'sl-fade-up 0.55s ease-out 0.55s both',
                            opacity: 0.7,
                        }}
                    >
                        Secure OAuth2 authentication powered by Keycloak
                    </p>
                </div>
            </div>
        </>
    );
}
