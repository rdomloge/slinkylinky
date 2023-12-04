

export default function TextInput({changeHandler, label, initialValue}) {

    return (
        <div className="w-full px-3 mb-6 md:mb-0 border-b border-teal-500 mt-4">
            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-name">
                {label}
            </label>
            <input onChange={(e)=>changeHandler(e.target.value)} defaultValue={initialValue} type="text"
                className="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"/>
        </div>
    );
}