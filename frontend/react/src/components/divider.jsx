export default function Divider({text, size="text-xl", id="divider-id"}) {
    return (
        <div className="relative inline-flex items-center justify-center w-full" id={id}>
                <hr className="w-4/5 h-px my-8 bg-gray-500 border-0"/>
                <span className="absolute px-3 font-medium text-gray-900 -translate-x-1/2 left-1/2 bg-white">
                    <p className={size}>{text}</p>
                </span>
            </div>
    )
}