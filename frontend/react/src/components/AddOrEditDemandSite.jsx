import { useAuth } from "@/auth/AuthProvider";
import CategorySelector from "@/components/CategorySelector";
import TextInput from '@/components/atoms/TextInput';
import SessionButton from "./atoms/Button";
import { fixForPosting } from "./CategoryUtil";
import { useState } from "react";
import { fetchWithAuth } from "@/utils/fetchWithAuth";


export default function AddOrEditDemandSite({demandSite}) {

    const { user } = useAuth();
    const [demandSiteName, setDemandSiteName] = useState(demandSite.name)
    const [demandSiteUrl, setDemandSiteUrl] = useState(demandSite.url)

    function submitHandler() {
        
        console.log("Demand: "+JSON.stringify(demandSite))
        const restUrl = "/.rest/demandsites"
        delete demandSite.domain
        demandSite.name = demandSiteName
        demandSite.url = demandSiteUrl
                
        fixForPosting(demandSite)

        if(demandSite.id) {
            demandSite.updatedBy = user.email

            fetchWithAuth(restUrl+"/"+demandSite.id, {
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
    }

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
                            <TextInput label="name" binding={demandSiteName} changeHandler={(e)=>{
                                setDemandSiteName(e)
                            }} />
                        </div>
                    </div>
                    <div className="flex flex-wrap -mx-3 mb-6">
                        <div className="w-full px-3">
                            <TextInput label="URL" changeHandler={(e)=>setDemandSiteUrl(e)} binding={demandSiteUrl}/>
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