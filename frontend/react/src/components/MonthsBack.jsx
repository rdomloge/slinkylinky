import { Link, useSearchParams } from 'react-router-dom';

export default function MonthsBack() {

    const [searchParams] = useSearchParams()

    function isLeapYear(year) {
        return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0));
    }

    function getDaysInMonth(year, month) {
        return [31, (isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
    }

    function goBackMonths(value) {
        var d = new Date(),
            n = d.getDate();
        d.setDate(1);
        d.setMonth(d.getMonth() - value);
        d.setDate(Math.min(n, getDaysInMonth(d.getFullYear(), d.getMonth())));
        return d;
    }

    function lastNMonths(n) {
        const months = [ new Date().toLocaleString('en-GB', { month: 'short' }) ]
        for(let i=0; i < n; i++) {
            months.push(goBackMonths(i+1).toLocaleString('en-GB', { month: 'short' }))
        }
        return months;
    }

    function isActive(pos) {
        var mm = searchParams.get('minusMonths');
        if(mm === null) mm = '0';
        return pos === Number(mm);
    }

    const months = lastNMonths(5);
    const entries = [
        { pos: 4, to: '/proposals?minusMonths=4', label: months[4] },
        { pos: 3, to: '/proposals?minusMonths=3', label: months[3] },
        { pos: 2, to: '/proposals?minusMonths=2', label: months[2] },
        { pos: 1, to: '/proposals?minusMonths=1', label: months[1] },
        { pos: 0, to: '/proposals',               label: months[0] },
    ];

    return (
        <div className="flex items-center gap-1">
            {entries.map(({ pos, to, label }) => (
                <Link
                    key={pos}
                    to={to}
                    rel="nofollow"
                    className={`px-3 py-1.5 rounded-full text-sm font-medium transition-colors ${
                        isActive(pos)
                            ? 'bg-indigo-600 text-white shadow-sm'
                            : 'text-slate-500 hover:text-slate-800 hover:bg-slate-100'
                    }`}
                >
                    {label}
                </Link>
            ))}
        </div>
    );
}
