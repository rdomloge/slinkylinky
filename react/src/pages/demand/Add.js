import React, {useState, useEffect} from 'react'
import CategorySelector from "@/components/CategorySelector";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";

export default function NewDemand() {

    const [demand, setDemand] = useState({})

    function submitHandler() {
        console.log("Demand: "+JSON.stringify(demand))
        const demandUrl = "http://localhost:8080/linkdemands"

        fetch(demandUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify(demand)
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                const locationUrl = resp.headers.get('Location')
                location.href = "/supplier/search/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
        ***REMOVED***
            else {
                console.log("Created failed");
        ***REMOVED***
    ***REMOVED***);
***REMOVED***

    function categoryChangeHandler(categories) {
        const categoryHrefs = categories.map(c => c.value)
        demand.categories = categoryHrefs
***REMOVED***

    return (
        <Layout>
            <PageTitle title="New demand"/>
            <div className="absolute top-4 right-4">
                <button id="createnew" onClick={submitHandler} 
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded">
                    Submit
                </button>
            </div>
            <div>
            <form className="w-full max-w-lg card">
                <div className="flex flex-wrap -mx-3 mb-6">
                    <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                        <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-name">
                            Name
                        </label>
                        <input onChange={(e)=>demand.name=e.target.value}
                            className="appearance-none block w-full bg-gray-200 text-gray-700 border border-red-500 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white" id="grid-name" type="text"/>
                        <p className="text-red-500 text-xs italic">Required</p>
                    </div>
                    <div className="w-full md:w-1/2 px-3">
                        <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-anchor-text">
                            Anchor text
                        </label>
                        <input onChange={(e)=>demand.anchorText=e.target.value} className="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" id="grid-anchor-text" type="text"/>
                    </div>
                </div>
                <div className="flex flex-wrap -mx-3 mb-6">
                    <div className="w-full px-3">
                        <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-url">
                            URL
                        </label>
                        <input onChange={(e)=>demand.url=e.target.value}
                            className="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" id="grid-url" />
                        <p className="text-gray-600 text-xs italic">We'll work out the domain from this</p>
                    </div>
                </div>
                <div className="flex flex-wrap -mx-3 mb-2">
                    <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
                        <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-da-needed">
                            DA needed
                        </label>
                        <input id="grid-da-needed" type="number" placeholder="DA" onChange={(e)=>demand.daNeeded=e.target.value}
                            className="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"/>
                        <p className="text-red-500 text-xs italic">Required</p>
                    </div>
                    <div className="w-full md:w-2/3 px-3 mb-6 md:mb-0">
                        <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-state">
                            Categories
                        </label>
                        <div className="relative">
                            <CategorySelector changeHandler={categoryChangeHandler}/>
                        </div>
                    </div>
                    <div className="w-full md:w-3/3 px-3 mb-6 md:mb-0">
                    <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-state">
                            Requested
                        </label>
                        <div className="relative">
                        <input id="grid-requested" type="date" placeholder="" onChange={(e)=>demand.requested=e.target.value}
                            className="appearance-none block w-full bg-gray-200 text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"/>
                        </div>
                    </div>
                </div>
                </form>
            </div>
        </Layout>
    );
}