import 'flowbite';
import { useState } from 'react';
import Modal from './Modal';

export default function DotMenu({items, classNames}) {

    const [menuOpen, setMenuOpen] = useState(false);
    
  
    return (
        <div className={classNames}>
            <button id="dropdownMenuIconButton" data-dropdown-toggle="dropdownDots" onClick={() => setMenuOpen(!menuOpen)} type="button"
                className="inline-flex items-center p-2 text-sm font-medium text-center text-gray-900 bg-white rounded-lg hover:bg-gray-100 focus:ring-4 focus:outline-none dark:text-white focus:ring-gray-50 dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-600">
            <svg className="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 4 15">
            <path d="M3.5 1.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Zm0 6.041a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Zm0 5.959a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Z"/>
            </svg>
            </button>
            
            <div id="dropdownDots" className={`z-50 absolute bg-white divide-y divide-gray-100 rounded-lg shadow-md border w-44 dark:bg-gray-700 dark:divide-gray-600 ${menuOpen?"":"hidden"}`}>
                <ul className="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdownMenuIconButton">
                {
                    items.map(item => {
                        return (
                            <li key={item.label}>
                                <a href="#" onClick={()=>{
                                    item.onClick() 
                                    setMenuOpen(false)}
                                ***REMOVED***
                                    className="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">{item.label}</a>
                            </li>
                        )
                ***REMOVED***)
            ***REMOVED***   
                </ul>
            </div>
        </div>
    );
}