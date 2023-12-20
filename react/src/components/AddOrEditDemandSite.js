'use client'

import { useSession } from "next-auth/react";
import CategorySelector from "@/components/CategorySelector";
import TextInput from '@/components/atoms/TextInput';
import SessionButton from "./atoms/Button";
import { fixForPosting } from "./CategoryUtil";


export default function AddOrEditDemandSite({demandSite}) {

    const { data: session } = useSession();

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demandSite))
        const demandSiteUrl = "/.rest/demandsites"
        delete demandSite.domain
                
        fixForPosting(demandSite)

        if(demandSite.id) {
            demandSite.updatedBy = session.user.email

            fetch(demandSiteUrl+"/"+demandSite.id, {
                method: 'PATCH',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(demandSite)
            }).then(resp => {
                if(resp.ok) {
                    location.href = "/demandsites";
                }
                else {
                    console.log("Patch failed: "+JSON.stringify(resp))
                }
            })
        }
    //     else {
    //         demandSite.createdBy = session.user.email
    //         fetch(demandSiteUrl, {
    //             method: 'POST',
    //             headers: {'Content-Type':'application/json'},
    //             body: JSON.stringify(demandSite)
    //         })
    //         .then( (resp) => {
    //             if(resp.ok) {
    //                 const locationUrl = resp.headers.get('Location')
    //                 console.log("New demandSite created at "+locationUrl)
    //                 location.href = "/demandSite";
    //             }
    //             else {
    //                 console.log("Created failed: "+JSON.stringify(resp));
    //             }
    //         });
        }
    // }

    function categoryChangeHandler(categories) {
        const categoryHrefs = categories.map(c => c.value)
        demandSite.categories = categoryHrefs
    }

    return (
        <div className="flex">
            <div className="flex-1">
                <div className="content-center mb-4">
                    <SessionButton label="Submit" clickHandler={submitHandler}/>
                </div>
                <div>
                <form className="w-full max-w-lg card">
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full px-3 mb-6 md:mb-0">
                            <TextInput label="name" initialValue={demandSite.name} changeHandler={(e)=>{
                                demandSite.name=e
                            }} />
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full px-3">
                            <TextInput label="URL" changeHandler={(e)=>demandSite.url=e} initialValue={demandSite.url}/>
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-2">
                        <div className="w-full md:w-2/3 px-3 mb-6 md:mb-0">
                            <CategorySelector changeHandler={categoryChangeHandler} label="Categories" initialValue={demandSite.categories}/>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
        </div>
    );
}