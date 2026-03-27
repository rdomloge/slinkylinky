import 'chart.js/auto';
import { Line } from "react-chartjs-2";

export default function LineGraph({ datapoints }) {
    const labels = datapoints.map(d => d.yearMonth);
    const values = datapoints.map(d => d.traffic);

    const data = {
        labels,
        datasets: [
            {
                label: 'Traffic',
                data: values,
                borderColor: '#6366f1',
                backgroundColor: 'rgba(99, 102, 241, 0.1)',
                borderWidth: 2,
                pointRadius: datapoints.length > 18 ? 0 : 3,
                pointHoverRadius: 5,
                pointBackgroundColor: '#6366f1',
                tension: 0.4,
                fill: true,
            },
        ],
    };

    const options = {
        responsive: true,
        plugins: {
            legend: { display: false },
            tooltip: {
                backgroundColor: '#1e293b',
                titleColor: '#94a3b8',
                bodyColor: '#f1f5f9',
                padding: 10,
                cornerRadius: 8,
                callbacks: {
                    label: ctx => {
                        const v = ctx.parsed.y;
                        if (v >= 1_000_000) return (v / 1_000_000).toFixed(1) + 'M visits';
                        if (v >= 1_000) return (v / 1_000).toFixed(1) + 'k visits';
                        return v + ' visits';
                    },
                },
            },
        },
        scales: {
            x: {
                grid: { display: false },
                ticks: { color: '#94a3b8', font: { size: 11 }, maxTicksLimit: 8 },
                border: { display: false },
            },
            y: {
                grid: { color: '#f1f5f9' },
                ticks: {
                    color: '#94a3b8',
                    font: { size: 11 },
                    maxTicksLimit: 5,
                    callback: v => {
                        if (v >= 1_000_000) return (v / 1_000_000).toFixed(1) + 'M';
                        if (v >= 1_000) return (v / 1_000).toFixed(0) + 'k';
                        return v;
                    },
                },
                border: { display: false },
            },
        },
    };

    return <Line data={data} options={options} />;
}
