import Link from 'next/link';
import { useRouter } from 'next/router'

export default function MonthsBack() {

    const router = useRouter()

    function isLeapYear(year) { 
        return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0)); 
***REMOVED***
    
    function getDaysInMonth(year, month) {
        return [31, (isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
***REMOVED***
    
    function goBackMonths(value) {
        var d = new Date(),
            n = d.getDate();
        d.setDate(1);
        d.setMonth(d.getMonth() - value);
        d.setDate(Math.min(n, getDaysInMonth(d.getFullYear(), d.getMonth())));
        return d;
***REMOVED***

    function lastNMonths(n) {
        const months = [ new Date().toLocaleString('default', { month: 'short' }) ]
        for(let i=0; i < n; i++) {
            months.push(goBackMonths(i+1).toLocaleString('default', { month: 'short' }))
    ***REMOVED***
        return months;
***REMOVED***

    function classFor(pos) {
        var mm = router.query.minusMonths;
        if(undefined === mm) mm = 0;
        
        return "inline-block p-1 " + (pos === Number(mm) ? "font-black" : "")
***REMOVED***

    const months = lastNMonths(5);
    return (
        <span>
            <div className={classFor(4)}>
                <a href="/proposals?minusMonths=4">
                    {months[4]}
                </a>
            </div>
            <div className={classFor(3)}>
                <a href="/proposals?minusMonths=3">
                    {months[3]}
                </a>
            </div>
            <div className={classFor(2)}>
                <a href="/proposals?minusMonths=2">
                    {months[2]}
                </a>
            </div>
            <div className={classFor(1)}>
                <a href="/proposals?minusMonths=1">
                    {months[1]}
                </a>
            </div>
            <div className={classFor(0)}>
                <a href="/proposals">
                    {months[0]}
                </a>
            </div>
        </span>
    );
}