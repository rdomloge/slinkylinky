export default function Divider({ text, size = "text-xl", id = "divider-id" }) {
    return (
        <div id={id} className="relative flex items-center gap-4 my-5">
            <span
                aria-hidden
                className="h-px flex-1"
                style={{ background: 'var(--ink-hair)' }}
            />
            <span
                className="relative flex items-center gap-2 px-4 py-1.5 rounded-full"
                style={{
                    background: 'var(--bg-paper)',
                    border: '1px solid var(--ink-hair)',
                    boxShadow: '0 1px 2px rgba(42,36,35,0.04)',
                }}
            >
                <span
                    aria-hidden
                    className="w-1.5 h-1.5 rounded-full shrink-0"
                    style={{ background: 'var(--ink-hair)' }}
                />
                <span
                    className={size}
                    style={{
                        fontFamily: "'Bricolage Grotesque', sans-serif",
                        fontWeight: 600,
                        letterSpacing: '-0.025em',
                        color: 'var(--ink-primary)',
                        lineHeight: 1.2,
                    }}
                >
                    {text}
                </span>
            </span>
            <span
                aria-hidden
                className="h-px flex-1"
                style={{ background: 'var(--ink-hair)' }}
            />
        </div>
    );
}
