import { Link } from 'react-router-dom';
import Profile from '../Profile';

export default function Header({ title, actions }) {
    return (
        <header
            className="sticky top-0 z-30 border-b"
            style={{
                background: 'rgba(255,255,255,0.88)',
                backdropFilter: 'blur(10px)',
                borderColor: 'var(--border-light)',
                boxShadow: '0 1px 3px 0 rgba(0,0,0,0.02), 0 1px 2px 0 rgba(0,0,0,0.01)',
            }}
        >
            <div className="flex items-center justify-between px-6 py-3 gap-4">
                {/* Breadcrumb: home icon + chevron + page title */}
                <div className="flex items-center gap-2 min-w-0">
                    <Link
                        to="/"
                        className="shrink-0 transition-colors"
                        style={{ color: 'var(--text-secondary)' }}
                        aria-label="Home"
                    >
                        <svg
                            className="w-4 h-4"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                            strokeWidth={2}
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"
                            />
                        </svg>
                    </Link>
                    {title && (
                        <>
                            <svg
                                className="w-3.5 h-3.5 shrink-0"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                                strokeWidth={2}
                                style={{ color: 'var(--border-light)' }}
                            >
                                <path
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                    d="M9 5l7 7-7 7"
                                />
                            </svg>
                            <h1
                                className="text-sm font-semibold truncate"
                                style={{
                                    fontFamily: "'Space Grotesk', sans-serif",
                                    color: 'var(--text-primary)',
                                }}
                            >
                                {title}
                            </h1>
                        </>
                    )}
                </div>

                {/* Right: actions + profile */}
                <div className="flex items-center gap-4 shrink-0">
                    {actions}
                    <Profile />
                </div>
            </div>
        </header>
    );
}
