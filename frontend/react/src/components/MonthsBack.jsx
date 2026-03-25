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

    function classFor(pos) {
        var mm = searchParams.get('minusMonths');
        if(undefined === mm) mm = 0;
        
        return "inline-block p-1 " + (pos === Number(mm) ? "font-black" : "")
    }

    const months = lastNMonths(5);
    return (
        <span className='display-block'>
            <div className={classFor(4)}>
                <Link to="/proposals?minusMonths=4" rel='nofollow'>
                    {months[4]}
                </Link>
            </div>
            <div className={classFor(3)}>
                <Link to="/proposals?minusMonths=3" rel='nofollow'>
                    {months[3]}
                </Link>
            </div>
            <div className={classFor(2)}>
                <Link to="/proposals?minusMonths=2" rel='nofollow'>
                    {months[2]}
                </Link>
            </div>
            <div className={classFor(1)}>
                <Link to="/proposals?minusMonths=1" rel='nofollow'>
                    {months[1]}
                </Link>
            </div>
            <div className={classFor(0)}>
                <Link to="/proposals" rel='nofollow'>
                    {months[0]}
                </Link>
            </div>
        </span>
    );
}