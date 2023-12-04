import React, {useState, useEffect} from 'react'
import CategorySelector from "@/components/CategorySelector";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import { useSession } from "next-auth/react";
import CategoryFilter from '@/components/CategorySelector';
import TextInput from '@/components/TextInput';
import NumberInput from '@/components/NumberInput';

export default function NewDemand() {

    const [demand, setDemand] = useState({})
    const { data: session } = useSession();

    function submitHandler() {
        demand.createdBy = session.user.email
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
                location.href = "/demand/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
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
            <div className="content-center mb-4">
                <button id="createnew" onClick={submitHandler} 
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 p-4 border border-blue-700 rounded">
                    Submit
                </button>
            </div>
            <div>
            <form className="w-full max-w-lg card">
                <div className="flex flex-wrap -mx-3 mb-6">
                    <div className="w-full md:w-1/2 px-3 mb-6 md:mb-0">
                        <TextInput label="name" changeHandler={(e)=>demand.name=e}/>
                    </div>
                    <div className="w-full md:w-1/2 px-3">
                        <TextInput label="Anchor text" changeHandler={(e)=>demand.anchorText=e} />
                    </div>
                </div>
                <div className="flex flex-wrap -mx-3 mb-6">
                    <div className="w-full px-3">
                        <TextInput label="URL" changeHandler={(e)=>demand.url=e} />
                    </div>
                </div>
                <div className="flex flex-wrap -mx-3 mb-2">
                    <div className="w-full md:w-1/3 px-3 mb-6 md:mb-0">
                        <NumberInput label="DA needed" changeHandler={(e)=>demand.daNeeded=e} />
                    </div>
                    <div className="w-full md:w-2/3 px-3 mb-6 md:mb-0">
                        <CategorySelector changeHandler={categoryChangeHandler} label="Categories"/>
                    </div>
                    <div className="w-full md:w-3/3 px-3 mb-6 mt-6 md:mb-0">
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