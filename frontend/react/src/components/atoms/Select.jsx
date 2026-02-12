
export default function Select({label, options, changeHandler, selected}) {
    return (
        <>
        <label htmlFor="countries" className="inline-block mb-2 text-sm font-medium text-gray-900 dark:text-white ml-10 mr-2">{label}</label>
        <select id="countries" onChange={ (e) => changeHandler(e.target.value)} defaultValue={selected}
            className="inline-block bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg 
            focus:ring-blue-500 focus:border-blue-500 block p-2.5 dark:bg-gray-700 dark:border-gray-600 
            dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">

        {options.map( (o,index) => <option value={o.value} key={index}>{o.name}</option>)}

        </select>
        </>
    );
}
