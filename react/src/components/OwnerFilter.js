import React, {useState} from 'react'

export default function OwnerFilter({changeHandler}) {
    const [isChecked, setIsChecked] = useState(false)

    const checkHandler = () => {
        setIsChecked(!isChecked)
        changeHandler(!isChecked) // needs to be inverse since the state is not changed until method exited
***REMOVED***


    return (
        <div className="relative inline-flex items-center cursor-pointer flex ml-6">
            <label className="relative inline-flex items-center cursor-pointer pr-2">
                <span className="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Everyone</span>
            </label>
            <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" value="" className="sr-only peer" onChange={checkHandler} checked={isChecked}/>
                <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600">
                </div>
                <span className="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Just me</span>
            </label>
        </div>
    );
}