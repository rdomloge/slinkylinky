export default function LabeledText({label, text, labelClasses, textClasses}) {
    return (
        <div className="w-full px-3 mb-8 mt-4">
            <label className={"block uppercase tracking-wide text-gray-400 text-xs font-bold mb-1 align-middle "+labelClasses} htmlFor="grid-name">
                {label}
            </label>
            <div className={"appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none "+textClasses}>
                {text}
            </div>
        </div>
    );
}