import React, {useState} from 'react'

export default function OwnerFilter({changeHandler}) {
    const [isChecked, setIsChecked] = useState(false)

    const checkHandler = () => {
        setIsChecked(!isChecked)
        changeHandler(!isChecked) // needs to be inverse since the state is not changed until method exited
    }


    return (
        <div className="relative inline-flex items-center cursor-pointer flex ml-6">
            <label className="relative inline-flex items-center cursor-pointer pr-2">
                <span className="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Everyone</span>
            </label>
            <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" value="" className="sr-only peer" onChange={checkHandler} checked={isChecked}/>
                <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-indigo-300 rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-600">
                </div>
                <span className="ms-3 text-sm font-medium text-gray-900 dark:text-gray-300">Just me</span>
            </label>
        </div>
    );
}