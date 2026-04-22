export function responsivenessLabel(avgDays) {
    if (avgDays == null) return { text: 'Unknown', tone: 'status-chip-neutral' };
    if (avgDays <= 7) return { text: 'Very responsive', tone: 'status-chip-supplier' };
    if (avgDays <= 14) return { text: 'Responsive', tone: 'status-chip-good' };
    if (avgDays <= 30) return { text: 'Average', tone: 'status-chip-warn' };
    if (avgDays <= 60) return { text: 'Slow', tone: 'status-chip-danger' };
    return { text: 'Very slow', tone: 'status-chip-danger' };
}

export default function ResponsivenessLabel({ avgResponseDays }) {
    const { text, tone } = responsivenessLabel(avgResponseDays);

    return (
        <span className={`status-chip ${tone}`}>
            {text}
        </span>
    );
}
