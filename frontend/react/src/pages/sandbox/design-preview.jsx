import React from 'react';
import Layout from '@/components/layout/Layout';

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
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div className="card supplier-card">
                                <div className="flex items-center gap-2 mb-2">
                                    <span className="entity-badge entity-badge-supplier">SUPPLIER</span>
                                </div>
                                <h4 className="font-bold">Supplier Card</h4>
                                <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
                                    Mint accent for growth-focused entities
                                </p>
                            </div>

                            <div className="card demand-card">
                                <div className="flex items-center gap-2 mb-2">
                                    <span className="entity-badge entity-badge-demand">DEMAND</span>
                                </div>
                                <h4 className="font-bold">Demand Card</h4>
                                <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
                                    Peach accent for action-oriented items
                                </p>
                            </div>

                            <div className="card demandsite-card">
                                <div className="flex items-center gap-2 mb-2">
                                    <span className="entity-badge entity-badge-demandsite">SITE</span>
                                </div>
                                <h4 className="font-bold">Demand Site Card</h4>
                                <p className="text-sm" style={{ color: 'var(--text-secondary)' }}>
                                    Lavender accent for destination entities
                                </p>
                            </div>
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
