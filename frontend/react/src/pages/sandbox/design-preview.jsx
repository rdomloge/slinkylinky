import React from 'react';
import Layout from '@/components/layout/Layout';

const PREVIEW_TOKENS = {
    panel: '#ffffff',
    panelAlt: '#f7f8fb',
    panelWarn: '#fffdf7',
    ink: '#151b29',
    inkSecondary: '#4b566e',
    inkMuted: '#6d7891',
    line: '#e7ebf2',
    lineStrong: '#d7deea',
    shadow: '0 18px 40px rgba(15, 23, 42, 0.08)',
    displayFont: '"Instrument Serif", "Iowan Old Style", "Palatino Linotype", serif',
    sansFont: '"Space Grotesk", ui-sans-serif, system-ui, sans-serif',
    monoFont: '"DM Mono", ui-monospace, monospace',
};

const PREVIEW_TONES = {
    neutral: {
        bg: '#f6f8fb',
        fg: '#5d6a84',
        bd: '#e3e8f0',
        glow: 'rgba(93, 106, 132, 0.14)',
    },
    supplier: {
        bg: '#e8f6f0',
        fg: '#4f8f79',
        bd: '#cfe8dc',
        glow: 'rgba(109, 184, 157, 0.18)',
    },
    accent: {
        bg: '#fff1e8',
        fg: '#a35e2d',
        bd: '#f2d4be',
        glow: 'rgba(163, 94, 45, 0.16)',
    },
    good: {
        bg: '#edf8f1',
        fg: '#317a5e',
        bd: '#cde9da',
        glow: 'rgba(49, 122, 94, 0.16)',
    },
    warn: {
        bg: '#fff4d9',
        fg: '#9a6c1c',
        bd: '#f0d79c',
        glow: 'rgba(154, 108, 28, 0.16)',
    },
    site: {
        bg: '#f6f1ff',
        fg: '#6a57a8',
        bd: '#e2d9fb',
        glow: 'rgba(106, 87, 168, 0.16)',
    },
};

const previewActionButtonStyle = (color) => ({
    background: 'none',
    border: 'none',
    color,
    cursor: 'pointer',
    fontFamily: PREVIEW_TOKENS.sansFont,
    fontSize: 12,
    fontWeight: 500,
    padding: 0,
});

const previewTitleStyle = {
    margin: 0,
    color: PREVIEW_TOKENS.ink,
    fontFamily: PREVIEW_TOKENS.sansFont,
    fontSize: 28,
    fontWeight: 500,
    letterSpacing: '-0.01em',
    lineHeight: 1,
};

const previewMonoRowStyle = {
    display: 'flex',
    alignItems: 'center',
    gap: 6,
    marginBottom: 12,
    color: PREVIEW_TOKENS.inkSecondary,
    fontFamily: PREVIEW_TOKENS.monoFont,
    fontSize: 12,
    minWidth: 0,
};

const previewFooterStyle = {
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    flexWrap: 'wrap',
    paddingTop: 12,
    borderTop: `1px solid ${PREVIEW_TOKENS.line}`,
    color: PREVIEW_TOKENS.inkMuted,
    fontFamily: PREVIEW_TOKENS.sansFont,
    fontSize: 11.5,
};

function PreviewIcon({ name, size = 14, color = 'currentColor', stroke = 1.75 }) {
    const paths = {
        link: (
            <>
                <path d="M10 14a5 5 0 0 0 7 0l3-3a5 5 0 0 0-7-7l-1 1" />
                <path d="M14 10a5 5 0 0 0-7 0l-3 3a5 5 0 0 0 7 7l1-1" />
            </>
        ),
        arrowDown: <path d="M12 5v14M5 12l7 7 7-7" />,
        cal: (
            <>
                <rect x="3" y="5" width="18" height="16" rx="1" />
                <path d="M3 9h18M8 3v4M16 3v4" />
            </>
        ),
        copy: (
            <>
                <rect x="8" y="8" width="12" height="12" rx="1" />
                <path d="M4 16V5a1 1 0 0 1 1-1h11" />
            </>
        ),
        bolt: <path d="M13 2L4 14h7l-1 8 9-12h-7l1-8z" />,
        clock: (
            <>
                <circle cx="12" cy="12" r="9" />
                <path d="M12 7v5l3 2" />
            </>
        ),
    };

    return (
        <svg
            width={size}
            height={size}
            viewBox="0 0 24 24"
            fill="none"
            stroke={color}
            strokeWidth={stroke}
            strokeLinecap="round"
            strokeLinejoin="round"
        >
            {paths[name]}
        </svg>
    );
}

function PreviewCard({ children, railColor, background = PREVIEW_TOKENS.panel }) {
    return (
        <div
            style={{
                position: 'relative',
                background,
                border: `1px solid ${PREVIEW_TOKENS.line}`,
                borderRadius: 18,
                boxShadow: PREVIEW_TOKENS.shadow,
                overflow: 'hidden',
                padding: '18px 18px 16px',
                fontFamily: PREVIEW_TOKENS.sansFont,
            }}
        >
            <div
                style={{
                    position: 'absolute',
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 3,
                    background: railColor,
                }}
            />
            {children}
        </div>
    );
}

function PreviewStatusDot({ tone = 'neutral' }) {
    const activeTone = PREVIEW_TONES[tone] || PREVIEW_TONES.neutral;

    return (
        <span
            style={{
                width: 8,
                height: 8,
                borderRadius: '50%',
                background: activeTone.fg,
                boxShadow: `0 0 0 4px ${activeTone.glow}`,
                flexShrink: 0,
                marginTop: 6,
            }}
        />
    );
}

function PreviewStatusChip({ tone = 'neutral', children }) {
    const activeTone = PREVIEW_TONES[tone] || PREVIEW_TONES.neutral;

    return (
        <span
            style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: 5,
                padding: '3px 9px',
                borderRadius: 999,
                background: activeTone.bg,
                color: activeTone.fg,
                border: `1px solid ${activeTone.bd}`,
                fontFamily: PREVIEW_TOKENS.monoFont,
                fontSize: 10.5,
                fontWeight: 500,
                letterSpacing: '0.08em',
                textTransform: 'uppercase',
            }}
        >
            <span
                style={{
                    width: 5,
                    height: 5,
                    borderRadius: '50%',
                    background: activeTone.fg,
                    opacity: 0.75,
                }}
            />
            {children}
        </span>
    );
}

function PreviewMetric({ label, value, tone = 'neutral' }) {
    const activeTone = PREVIEW_TONES[tone] || PREVIEW_TONES.neutral;

    return (
        <span
            style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: 4,
                padding: '3px 8px',
                borderRadius: 8,
                background: activeTone.bg,
                color: activeTone.fg,
                border: `1px solid ${activeTone.bd}`,
                fontFamily: PREVIEW_TOKENS.monoFont,
                fontSize: 11,
                fontWeight: 500,
            }}
        >
            {label ? <span style={{ opacity: 0.7 }}>{label}</span> : null}
            <span>{value}</span>
        </span>
    );
}

function PreviewEntityBadge({ kind }) {
    const map = {
        supplier: { label: 'SUPPLIER', bg: '#e8f6f0', fg: '#4f8f79', bd: '#cfe8dc' },
        demand: { label: 'DEMAND', bg: '#fff4ec', fg: '#915a33', bd: '#f2dcc7' },
        'demand-site': { label: 'DEMAND SITE', bg: '#f6f1ff', fg: '#6a57a8', bd: '#e2d9fb' },
    };
    const entity = map[kind];

    return (
        <span
            style={{
                display: 'inline-flex',
                alignItems: 'center',
                padding: '3px 8px',
                borderRadius: 6,
                background: entity.bg,
                color: entity.fg,
                border: `1px solid ${entity.bd}`,
                fontFamily: PREVIEW_TOKENS.monoFont,
                fontSize: 10,
                fontWeight: 500,
                letterSpacing: '0.08em',
                textTransform: 'uppercase',
            }}
        >
            {entity.label}
        </span>
    );
}

function PreviewCategoryChip({ tone = 'neutral', children }) {
    const activeTone = {
        bg: '#eef5f1',
        fg: '#4f6c60',
        bd: '#d7e5de',
    };

    return (
        <span
            style={{
                display: 'inline-flex',
                alignItems: 'center',
                padding: '4px 10px',
                borderRadius: 999,
                background: activeTone.bg,
                color: activeTone.fg,
                border: `1px solid ${activeTone.bd}`,
                fontFamily: PREVIEW_TOKENS.sansFont,
                fontSize: 11.5,
                fontWeight: 500,
                lineHeight: 1.4,
                whiteSpace: 'nowrap',
            }}
        >
            {children}
        </span>
    );
}

export default function DesignPreview() {
    return (
        <Layout pagetitle="Design System Preview">
            <div className="max-w-6xl mx-auto px-4 py-8">
                {/* Header */}
                <div className="mb-12">
                    <h1
                        className="text-4xl font-bold mb-2"
                        style={{ fontFamily: "'Space Grotesk', sans-serif" }}
                    >
                        Connection-Inspired Design System
                    </h1>
                    <p className="text-lg" style={{ color: 'var(--text-secondary)' }}>
                        Sophisticated, minimal aesthetic with pastel accents and flowing animations
                    </p>
                </div>

                {/* Color Palette */}
                <section className="mb-12">
                    <h2 className="text-2xl font-bold mb-6" style={{ fontFamily: "'Space Grotesk', sans-serif" }}>
                        Color Palette
                    </h2>

                    {/* Base Colors */}
                    <div className="mb-8">
                        <h3 className="text-lg font-semibold mb-4">Base Colors</h3>
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                            {[
                                { name: 'Primary BG', hex: '#fafbfc' },
                                { name: 'Secondary BG', hex: '#f5f5f5' },
                                { name: 'Tertiary BG', hex: '#efefef' },
                                { name: 'Border', hex: '#e8e8e8' },
                                { name: 'Text Primary', hex: '#2c3e50' },
                                { name: 'Text Secondary', hex: '#5a6c7d' },
                            ].map((color) => (
                                <div key={color.hex} className="card p-4">
                                    <div
                                        className="w-full h-20 rounded-lg mb-3 border"
                                        style={{
                                            backgroundColor: color.hex,
                                            borderColor: 'var(--border-light)',
                                        }}
                                    />
                                    <p className="font-semibold text-sm">{color.name}</p>
                                    <p className="text-xs" style={{ color: 'var(--text-secondary)' }}>
                                        {color.hex}
                                    </p>
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Entity Colors */}
                    <div>
                        <h3 className="text-lg font-semibold mb-4">Entity Colors (Pastels)</h3>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            {[
                                {
                                    name: 'Supplier',
                                    accent: '#6db89d',
                                    bg: '#e8f6f0',
                                    desc: 'Soft Mint — Growth & Connection',
                                },
                                {
                                    name: 'Demand',
                                    accent: '#d4a574',
                                    bg: '#faf2e8',
                                    desc: 'Soft Peach — Warmth & Movement',
                                },
                                {
                                    name: 'Demand Site',
                                    accent: '#a89dbd',
                                    bg: '#f1ebe8',
                                    desc: 'Soft Lavender — Aspiration & Elegance',
                                },
                            ].map((color) => (
                                <div key={color.name} className="card p-6">
                                    <div
                                        className="w-full h-24 rounded-lg mb-4"
                                        style={{ backgroundColor: color.bg }}
                                    />
                                    <p className="font-bold text-lg">{color.name}</p>
                                    <p className="text-sm mb-3" style={{ color: 'var(--text-secondary)' }}>
                                        {color.desc}
                                    </p>
                                    <div className="flex items-center gap-2">
                                        <div
                                            className="w-8 h-8 rounded"
                                            style={{ backgroundColor: color.accent }}
                                        />
                                        <code className="text-xs">{color.accent}</code>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </section>

                {/* Typography */}
                <section className="mb-12">
                    <h2 className="text-2xl font-bold mb-6" style={{ fontFamily: "'Space Grotesk', sans-serif" }}>
                        Typography
                    </h2>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div className="card p-6">
                            <h3 className="text-sm uppercase tracking-wider mb-4 font-semibold">
                                Display
                            </h3>
                            <p
                                className="text-3xl font-bold mb-2"
                                style={{ fontFamily: "'Space Grotesk', sans-serif" }}
                            >
                                Space Grotesk
                            </p>
                            <p className="text-xs" style={{ color: 'var(--text-secondary)' }}>
                                Modern, geometric, distinctive<br />700–800 weight
                            </p>
                        </div>

                        <div className="card p-6">
                            <h3 className="text-sm uppercase tracking-wider mb-4 font-semibold">
                                Body
                            </h3>
                            <p
                                className="text-lg mb-2"
                                style={{ fontFamily: "'Space Grotesk', sans-serif" }}
                            >
                                Space Grotesk
                            </p>
                            <p className="text-xs" style={{ color: 'var(--text-secondary)' }}>
                                Clean, legible, contemporary<br />400–500 weight
                            </p>
                        </div>

                        <div className="card p-6">
                            <h3 className="text-sm uppercase tracking-wider mb-4 font-semibold">
                                Mono
                            </h3>
                            <p
                                className="text-base font-mono mb-2"
                                style={{ fontFamily: "'DM Mono', monospace" }}
                            >
                                DM Mono
                            </p>
                            <p className="text-xs" style={{ color: 'var(--text-secondary)' }}>
                                Data, badges, technical<br />400–500 weight
                            </p>
                        </div>
                    </div>
                </section>

                {/* Components */}
                <section className="mb-12">
                    <h2 className="text-2xl font-bold mb-6" style={{ fontFamily: "'Space Grotesk', sans-serif" }}>
                        Component Variants
                    </h2>

                    {/* Cards */}
                    <div className="mb-8">
                        <h3 className="text-lg font-semibold mb-4">Cards</h3>
                        <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
                            <PreviewCard railColor="#6db89d">
                                <div className="flex items-start gap-3 mb-4">
                                    <PreviewStatusDot tone="supplier" />
                                    <div className="flex-1 min-w-0">
                                        <div className="flex flex-wrap items-center gap-2 mb-2">
                                            <PreviewEntityBadge kind="supplier" />
                                            <PreviewStatusChip tone="supplier">Very responsive</PreviewStatusChip>
                                        </div>
                                        <h4 style={previewTitleStyle}>examplepublisher.co.uk</h4>
                                    </div>
                                    <button style={previewActionButtonStyle(PREVIEW_TOKENS.inkMuted)}>Edit</button>
                                </div>

                                <div style={previewMonoRowStyle}>
                                    <PreviewIcon name="link" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                    <span className="truncate">https://examplepublisher.co.uk/tech</span>
                                </div>

                                <div className="flex flex-wrap gap-2 mb-4">
                                    <PreviewMetric label="DA" value="58" tone="supplier" />
                                    <PreviewMetric label="£" value="145" />
                                    <PreviewMetric label="Traffic" value="12.4k" />
                                </div>

                                <div className="flex flex-wrap gap-2 mb-4">
                                    <PreviewCategoryChip tone="mint">Business</PreviewCategoryChip>
                                    <PreviewCategoryChip tone="blue">Marketing</PreviewCategoryChip>
                                    <PreviewCategoryChip tone="peach">Tech</PreviewCategoryChip>
                                </div>

                                <div style={previewFooterStyle}>
                                    <span className="inline-flex items-center gap-1.5">
                                        <PreviewIcon name="clock" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                        12-mo growth +18%
                                    </span>
                                    <div className="flex-1" />
                                    <span
                                        style={{
                                            display: 'inline-flex',
                                            alignItems: 'center',
                                            gap: 5,
                                            padding: '3px 9px',
                                            borderRadius: 999,
                                            background: PREVIEW_TOKENS.panelAlt,
                                            border: `1px solid ${PREVIEW_TOKENS.line}`,
                                            fontFamily: PREVIEW_TOKENS.monoFont,
                                            fontSize: 10.5,
                                        }}
                                    >
                                        <PreviewIcon name="bolt" size={10} color={PREVIEW_TOKENS.inkMuted} />
                                        1% spam
                                    </span>
                                </div>
                            </PreviewCard>

                            <PreviewCard railColor="#cf8452">
                                <div className="flex items-start gap-3 mb-4">
                                    <PreviewStatusDot tone="accent" />
                                    <div className="flex-1 min-w-0">
                                        <div className="flex flex-wrap items-center gap-2 mb-2">
                                            <PreviewEntityBadge kind="demand" />
                                            <PreviewStatusChip tone="accent">Open</PreviewStatusChip>
                                        </div>
                                        <h4 style={previewTitleStyle}>The Skin Wellness Edit</h4>
                                    </div>
                                    <div className="flex items-center gap-3">
                                        <button style={previewActionButtonStyle(PREVIEW_TOKENS.inkMuted)}>Edit</button>
                                        <button style={previewActionButtonStyle('#c55e47')}>Delete</button>
                                    </div>
                                </div>

                                <div style={previewMonoRowStyle}>
                                    <PreviewIcon name="link" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                    <span className="truncate">https://theskinwellnessedit.com/wellness-partners</span>
                                </div>

                                <div
                                    style={{
                                        display: 'flex',
                                        alignItems: 'center',
                                        gap: 6,
                                        marginBottom: 12,
                                        color: PREVIEW_TOKENS.inkSecondary,
                                        fontFamily: PREVIEW_TOKENS.sansFont,
                                        fontSize: 13,
                                        fontStyle: 'italic',
                                    }}
                                >
                                    <PreviewIcon name="arrowDown" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                    <span>best collagen supplements</span>
                                </div>

                                <div className="flex flex-wrap gap-2 mb-4">
                                    <PreviewMetric label="DA" value="40+" tone="good" />
                                    <PreviewMetric value="6m age" />
                                </div>

                                <div className="flex flex-wrap gap-2 mb-4">
                                    <PreviewCategoryChip tone="peach">Health &amp; Wellness</PreviewCategoryChip>
                                    <PreviewCategoryChip tone="rose">Lifestyle</PreviewCategoryChip>
                                </div>

                                <div style={previewFooterStyle}>
                                    <span className="inline-flex items-center gap-1.5">
                                        <PreviewIcon name="cal" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                        Requested 22 Apr
                                    </span>
                                    <span>·</span>
                                    <span style={{ fontFamily: PREVIEW_TOKENS.monoFont }}>RD</span>
                                    <div className="flex-1" />
                                    <PreviewIcon name="copy" size={13} color={PREVIEW_TOKENS.inkMuted} />
                                </div>
                            </PreviewCard>

                            <PreviewCard railColor="#a89dbd" background={PREVIEW_TOKENS.panelWarn}>
                                <div className="flex items-start gap-3 mb-4">
                                    <PreviewStatusDot tone="warn" />
                                    <div className="flex-1 min-w-0">
                                        <div className="flex flex-wrap items-center gap-2 mb-2">
                                            <PreviewEntityBadge kind="demand-site" />
                                            <PreviewStatusChip tone="warn">Needs categories</PreviewStatusChip>
                                        </div>
                                        <h4 style={previewTitleStyle}>River Vista Travel</h4>
                                    </div>
                                    <div className="flex items-center gap-3">
                                        <button style={previewActionButtonStyle(PREVIEW_TOKENS.inkMuted)}>Edit</button>
                                        <button style={previewActionButtonStyle('#4b67d1')}>History</button>
                                    </div>
                                </div>

                                <div style={previewMonoRowStyle}>
                                    <PreviewIcon name="link" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                    <span className="truncate">rivervistatravel.com</span>
                                </div>

                                <div
                                    style={{
                                        display: 'inline-flex',
                                        alignItems: 'center',
                                        gap: 8,
                                        padding: '10px 12px',
                                        borderRadius: 12,
                                        background: PREVIEW_TONES.warn.bg,
                                        color: PREVIEW_TONES.warn.fg,
                                        border: `1px solid ${PREVIEW_TONES.warn.bd}`,
                                        fontFamily: PREVIEW_TOKENS.sansFont,
                                        fontSize: 12.5,
                                        fontWeight: 500,
                                    }}
                                >
                                    <PreviewIcon name="bolt" size={11} color={PREVIEW_TONES.warn.fg} />
                                    No categories set — won&apos;t match any suppliers
                                </div>

                                <div style={{ ...previewFooterStyle, marginTop: 14 }}>
                                    <span>Missing categories</span>
                                    <div className="flex-1" />
                                    <span style={{ fontFamily: PREVIEW_TOKENS.monoFont }}>1 affected site</span>
                                </div>
                            </PreviewCard>

                            <PreviewCard railColor="#a89dbd">
                                <div className="flex items-start gap-3 mb-4">
                                    <PreviewStatusDot tone="site" />
                                    <div className="flex-1 min-w-0">
                                        <div className="flex flex-wrap items-center gap-2 mb-2">
                                            <PreviewEntityBadge kind="demand-site" />
                                        </div>
                                        <h4 style={previewTitleStyle}>North Coast Living</h4>
                                    </div>
                                    <div className="flex items-center gap-3">
                                        <button style={previewActionButtonStyle(PREVIEW_TOKENS.inkMuted)}>Edit</button>
                                        <button style={previewActionButtonStyle('#4b67d1')}>History</button>
                                        <button style={previewActionButtonStyle('#c55e47')}>Delete</button>
                                    </div>
                                </div>

                                <div style={previewMonoRowStyle}>
                                    <PreviewIcon name="link" size={12} color={PREVIEW_TOKENS.inkMuted} />
                                    <span className="truncate">northcoastliving.com</span>
                                </div>

                                <div className="flex flex-wrap gap-2 mb-4">
                                    <PreviewCategoryChip>Home &amp; Garden</PreviewCategoryChip>
                                    <PreviewCategoryChip>Travel</PreviewCategoryChip>
                                    <PreviewCategoryChip>Lifestyle</PreviewCategoryChip>
                                </div>

                                <div style={previewFooterStyle}>
                                    <span>Categories assigned</span>
                                    <div className="flex-1" />
                                    <span style={{ fontFamily: PREVIEW_TOKENS.monoFont }}>Ready for matching</span>
                                </div>
                            </PreviewCard>
                        </div>
                    </div>

                    {/* Badges & Chips */}
                    <div>
                        <h3 className="text-lg font-semibold mb-4">Badges & Chips</h3>
                        <div className="card p-6">
                            <div className="flex flex-wrap gap-3">
                                <span className="stat-chip-supplier">
                                    🌱 Supplier
                                </span>
                                <span className="stat-chip-demand">
                                    🔥 Demand
                                </span>
                                <span className="stat-chip-demandsite">
                                    🎯 Site
                                </span>
                            </div>
                        </div>
                    </div>
                </section>

                {/* Design Philosophy */}
                <section>
                    <h2 className="text-2xl font-bold mb-6" style={{ fontFamily: "'Space Grotesk', sans-serif" }}>
                        Design Philosophy
                    </h2>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        {[
                            {
                                title: 'Sleek & Modern',
                                desc: 'Clean lines, refined spacing, sophisticated typography',
                            },
                            {
                                title: 'Connection Theme',
                                desc: 'Visual hints of networks and nodes throughout the interface',
                            },
                            {
                                title: 'Pastel Palette',
                                desc: 'Soft, complementary colors instead of aggressive primaries',
                            },
                            {
                                title: 'Minimal Shadows',
                                desc: 'Subtle depth with refined shadow hierarchy',
                            },
                            {
                                title: 'Organic Motion',
                                desc: 'Smooth, flowing animations suggesting connection & flow',
                            },
                            {
                                title: 'Refined Elegance',
                                desc: 'Professional B2B aesthetic with attention to detail',
                            },
                        ].map((item) => (
                            <div key={item.title} className="card p-4">
                                <h4 className="font-bold mb-2">{item.title}</h4>
                                <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
                                    {item.desc}
                                </p>
                            </div>
                        ))}
                    </div>
                </section>

                {/* Footer */}
                <div className="mt-12 pt-8 border-t" style={{ borderColor: 'var(--border-light)' }}>
                    <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
                        Design system v1.0 — See DESIGN_GUIDE.md for detailed documentation
                    </p>
                </div>
            </div>
        </Layout>
    );
}
