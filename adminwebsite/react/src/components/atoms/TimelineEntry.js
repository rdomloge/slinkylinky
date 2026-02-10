import React, {useState, PureComponent } from 'react';
import ReactDiffViewer, { DiffMethod } from 'react-diff-viewer-continued';
import { NiceDateTime } from './DateTime';

export default function TimelineEntry(props) {
    const [showDiff, setShowDiff] = useState()

    return(
        <li className="mb-10 ms-4">
            <div className="absolute w-4 h-4 bg-blue-400 rounded-full mt-1.5 timelineDot border border-white dark:border-gray-900 dark:bg-gray-700"></div>
            <time className="mb-1 text-sm font-normal leading-none text-gray-600 dark:text-gray-500"><NiceDateTime isostring={props.date}/></time>
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white capitalize">{props.what}</h3>
            <h3 className="text-sm font-semibold text-blue-900 dark:text-white">{props.who}</h3>
            
            <label htmlFor="message" className="block mb-2 text-sm font-medium text-gray-900 dark:text-white mt-4">Object details</label>
            <textarea id="message" rows="4" placeholder="No point editing this..." value={props.detail} readOnly
                className="block p-2.5 w-1/2 text-sm font-mono mr-8 text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
            </textarea>
            <a href="#" onClick={()=>setShowDiff(! showDiff)}
                className="inline-flex items-center px-4 py-2 text-sm  font-medium text-gray-900 bg-white border border-gray-200 rounded-lg hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:outline-none focus:ring-gray-200 focus:text-blue-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700 dark:focus:ring-gray-700">
                Show diff 
                <svg className="w-3 h-3 ms-2 rtl:rotate-180" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
                    <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
                </svg>
            </a>
            {showDiff ?
                <ReactDiffViewer oldValue={props.previousDetail} newValue={props.detail} splitView={true} 
                    showDiffOnly={true} extraLinesSurroundingDiff={0} compareMethod={DiffMethod.WORDS}
                    hideLineNumbers={true}/>
            :null}
        </li>
    );
}

