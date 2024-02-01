export default function Counter({count, low, medium, high}) {

    const baseClass = "text-slate-100 font-bold py-1 px-2 border rounded disabled:opacity-50 ml-2 "
    const lowClass = baseClass + "bg-blue-200 border-blue-400"
    const mediumClass = baseClass + "bg-green-500 border-green-900"
    const highClass = baseClass + "bg-yellow-500 border-yellow-900"
    const veryhighClass = baseClass + "bg-red-500 border-red-900"

    if(count < low) return (
        <span className={lowClass}>{count}</span>
    )
    if(count < medium) return (
        <span className={mediumClass}>{count}</span>
    )
    if(count < high) return (
        <span className={highClass}>{count}</span>
    )
    return (
        <span className={veryhighClass}>{count}</span>
    )
}