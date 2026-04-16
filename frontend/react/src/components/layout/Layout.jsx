import React, { useEffect, useState, useRef } from 'react';
import Menu from './Menu';
import Footer from './Footer';
import Header from './Header';
import { useAuth } from '@/auth/AuthProvider';
import TenantBadge from '../TenantBadge';
import Logo from '@/assets/logo.png';

const ENTITY_CHIPS = [
    { label: 'Suppliers', bg: 'rgba(5,150,105,0.1)',   color: '#34d399', border: 'rgba(52,211,153,0.22)'   },
    { label: 'Demand',    bg: 'rgba(217,119,6,0.1)',    color: '#fbbf24', border: 'rgba(251,191,36,0.22)'   },
    { label: 'Sites',     bg: 'rgba(124,58,237,0.1)',   color: '#a78bfa', border: 'rgba(167,139,250,0.22)'  },
];

export default function Layout({ children, pagetitle = ' ', headerTitle, headerActions }) {
    const { user, isAuthenticated, isLoading, signIn } = useAuth();
    const [launching, setLaunching] = useState(false);
    const [launchOrigin, setLaunchOrigin] = useState({ x: '50%', y: '50%' });
    const [entered, setEntered] = useState(false);
    const buttonRef = useRef(null);
    const overlayRef = useRef(null);

    useEffect(() => {
        if (pagetitle) document.title = 'Slinky Linky | ' + pagetitle;
    }, [pagetitle]);

    // Entry animation on fresh login return
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

    // Expand portal overlay after it's painted with initial clip-path
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
                        className="w-56 shrink-0 flex flex-col border-r border-white/5 overflow-y-auto"
                        style={{ background: 'linear-gradient(180deg, #0f172a 0%, #1e1b4b 100%)' }}
                    >
                        <TenantBadge />
                        <a
                            href="/"
                            className="flex items-center gap-3 px-4 py-[1.1rem] shrink-0 border-b border-white/10 hover:bg-white/5 transition-colors group"
                        >
                            <img
                                src={Logo}
                                width={Math.round(439 / 10)} height={Math.round(498 / 10)}
                                alt="Logo"
                                className="brightness-0 invert opacity-80 group-hover:opacity-100 transition-opacity"
                            />
                            <span
                                className="text-white font-extrabold text-base"
                                style={{ fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.03em' }}
                            >
                                Slinky<span style={{ color: '#a78bfa' }}>Linky</span>
                            </span>
                        </a>
                        <Menu />
                    </aside>
                    <div className="flex flex-col flex-1 min-w-0" style={{ background: '#f0f2f7' }}>
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
            <div style={{
                display: 'flex', justifyContent: 'center', alignItems: 'center',
                height: '100vh',
                background: 'linear-gradient(135deg, #0a0e1a 0%, #0f172a 60%, #1e1b4b 100%)',
            }}>
                <div style={{ position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <img
                        src={Logo} width={44} height={50} alt="SlinkyLinky"
                        style={{
                            filter: 'brightness(0) invert(1)', opacity: 0.75,
                            animation: 'sl-callback-breathe 2s ease-in-out infinite',
                        }}
                    />
                    <div style={{
                        position: 'absolute', width: 80, height: 80, borderRadius: '50%',
                        border: '1.5px solid rgba(167,139,250,0.35)',
                        animation: 'sl-ping-ring 1.6s ease-out infinite',
                    }} />
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
                        position: 'fixed', inset: 0, zIndex: 200,
                        background: 'linear-gradient(135deg, #4f46e5 0%, #6d28d9 100%)',
                        clipPath: `circle(4px at ${launchOrigin.x} ${launchOrigin.y})`,
                        transition: 'clip-path 0.65s cubic-bezier(0.4, 0, 0.2, 1)',
                        willChange: 'clip-path',
                        display: 'flex', alignItems: 'center', justifyContent: 'center',
                    }}
                >
                    <img
                        src={Logo} width={44} height={50} alt="SlinkyLinky"
                        style={{
                            filter: 'brightness(0) invert(1)',
                            animation: 'sl-fade-up 0.3s ease-out 0.4s both',
                        }}
                    />
                </div>
            )}

            <div style={{
                position: 'fixed', inset: 0,
                background: 'linear-gradient(135deg, #0a0e1a 0%, #0f172a 55%, #1e1b4b 100%)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                overflow: 'hidden',
                fontFamily: "'Outfit', sans-serif",
            }}>
                {/* Ambient orbs */}
                <div style={{
                    position: 'absolute', top: '8%', left: '3%',
                    width: 700, height: 700,
                    background: 'radial-gradient(circle, rgba(5,150,105,0.14) 0%, transparent 68%)',
                    borderRadius: '50%', filter: 'blur(52px)',
                    animation: 'sl-orb-drift-a 20s ease-in-out infinite',
                    pointerEvents: 'none',
                }} />
                <div style={{
                    position: 'absolute', bottom: '2%', right: '5%',
                    width: 600, height: 600,
                    background: 'radial-gradient(circle, rgba(217,119,6,0.12) 0%, transparent 68%)',
                    borderRadius: '50%', filter: 'blur(52px)',
                    animation: 'sl-orb-drift-b 25s ease-in-out infinite',
                    pointerEvents: 'none',
                }} />
                <div style={{
                    position: 'absolute', top: '35%', right: '12%',
                    width: 450, height: 450,
                    background: 'radial-gradient(circle, rgba(124,58,237,0.17) 0%, transparent 68%)',
                    borderRadius: '50%', filter: 'blur(44px)',
                    animation: 'sl-orb-drift-c 18s ease-in-out infinite',
                    pointerEvents: 'none',
                }} />

                {/* Dot grid */}
                <div style={{
                    position: 'absolute', inset: 0,
                    backgroundImage: 'radial-gradient(circle, rgba(255,255,255,0.055) 1px, transparent 1px)',
                    backgroundSize: '30px 30px',
                    pointerEvents: 'none',
                }} />

                {/* Main content */}
                <div style={{
                    position: 'relative', zIndex: 1,
                    textAlign: 'center', maxWidth: 380, width: '100%', padding: '0 1.5rem',
                }}>
                    {/* Logo + wordmark */}
                    <div style={{
                        display: 'flex', alignItems: 'center', justifyContent: 'center',
                        gap: 12, marginBottom: 52,
                        animation: 'sl-fade-up 0.55s ease-out 0.1s both',
                    }}>
                        <img
                            src={Logo}
                            width={Math.round(439 / 8)} height={Math.round(498 / 8)}
                            alt="SlinkyLinky"
                            style={{ filter: 'brightness(0) invert(1)', opacity: 0.88 }}
                        />
                        <span style={{
                            fontSize: '1.8rem', fontWeight: 800, color: 'white',
                            letterSpacing: '-0.04em', lineHeight: 1,
                        }}>
                            Slinky<span style={{ color: '#a78bfa' }}>Linky</span>
                        </span>
                    </div>

                    {/* Headline */}
                    <h1 style={{
                        fontSize: '2.5rem', fontWeight: 800, color: 'white',
                        letterSpacing: '-0.045em', lineHeight: 1.12, margin: '0 0 14px',
                        animation: 'sl-fade-up 0.55s ease-out 0.2s both',
                    }}>
                        Links,<br /><span style={{ color: '#a78bfa' }}>connected.</span>
                    </h1>

                    <p style={{
                        color: 'rgba(148,163,184,0.82)', fontSize: '1rem', lineHeight: 1.65,
                        margin: '0 0 40px',
                        animation: 'sl-fade-up 0.55s ease-out 0.3s both',
                    }}>
                        Link intelligence for SEO teams.
                    </p>

                    {/* Entity chips */}
                    <div style={{
                        display: 'flex', justifyContent: 'center', gap: 8, marginBottom: 44,
                        animation: 'sl-fade-up 0.55s ease-out 0.4s both',
                    }}>
                        {ENTITY_CHIPS.map(({ label, bg, color, border }) => (
                            <span key={label} style={{
                                fontFamily: "'JetBrains Mono', monospace",
                                fontSize: '0.63rem', fontWeight: 600,
                                letterSpacing: '0.1em', textTransform: 'uppercase',
                                padding: '0.38em 0.85em', borderRadius: 99,
                                background: bg, color, border: `1px solid ${border}`,
                            }}>{label}</span>
                        ))}
                    </div>

                    {/* Sign-in button */}
                    <div style={{ animation: 'sl-fade-up 0.55s ease-out 0.5s both' }}>
                        <button
                            ref={buttonRef}
                            onClick={handleSignIn}
                            disabled={launching}
                            style={{
                                width: '100%', padding: '0.95rem 2rem',
                                background: 'linear-gradient(135deg, #4f46e5 0%, #6d28d9 100%)',
                                color: 'white', fontFamily: "'Outfit', sans-serif",
                                fontWeight: 600, fontSize: '1.025rem', letterSpacing: '-0.01em',
                                border: 'none', borderRadius: 14,
                                cursor: launching ? 'default' : 'pointer',
                                display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
                                boxShadow: '0 4px 28px rgba(99,102,241,0.38)',
                                transition: 'box-shadow 0.2s ease',
                                position: 'relative', overflow: 'hidden',
                            }}
                            onMouseEnter={e => { if (!launching) e.currentTarget.style.boxShadow = '0 8px 36px rgba(99,102,241,0.55)'; }}
                            onMouseLeave={e => { if (!launching) e.currentTarget.style.boxShadow = '0 4px 28px rgba(99,102,241,0.38)'; }}
                        >
                            {/* Shimmer layer */}
                            <span style={{
                                position: 'absolute', inset: 0,
                                background: 'linear-gradient(105deg, transparent 30%, rgba(255,255,255,0.07) 50%, transparent 70%)',
                            }} />
                            {launching ? (
                                <span style={{ display: 'flex', gap: 5, alignItems: 'center', position: 'relative' }}>
                                    {[0, 160, 320].map(d => (
                                        <span key={d} style={{
                                            width: 5, height: 5, borderRadius: '50%', background: 'white',
                                            animation: 'sl-loading-dot 1.1s ease-in-out infinite',
                                            animationDelay: `${d}ms`,
                                        }} />
                                    ))}
                                </span>
                            ) : (
                                <>
                                    <span style={{ position: 'relative' }}>Sign in with SSO</span>
                                    <svg width="15" height="15" viewBox="0 0 15 15" fill="none" style={{ position: 'relative' }}>
                                        <path d="M2 7.5h11M9 3l4 4.5-4 4.5" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" />
                                    </svg>
                                </>
                            )}
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}
