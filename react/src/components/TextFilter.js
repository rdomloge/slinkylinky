

export default function TextFilter({changeHandler, label}) {

    return (
        <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-name">
                {label}
            </label>
            <input onChange={(e)=>changeHandler(e.target.value)}
                className="appearance-none block w-full bg-gray-200 text-gray-700 border border-blue-500 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white" id="grid-name" type="text"/>
        </div>
    );
}