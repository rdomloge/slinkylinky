export default function Divider({text, size="text-xl", id="divider-id"}) {
    return (
        <div className="relative inline-flex items-center justify-center w-full my-2" id={id}>
            <hr className="w-full h-px bg-slate-200 border-0"/>
            <span className="absolute px-4 font-semibold text-slate-500 -translate-x-1/2 left-1/2 bg-slate-50">
                <p className={size}>{text}</p>
            </span>
        </div>
    )
}
