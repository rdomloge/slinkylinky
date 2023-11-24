import React, {useState} from 'react'

export default function SelectableLinkDemandCard({children, onSelectedHandler, onDeselectedHandler}) {
    const [checked, setChecked] = useState(false);

    const handleChange = () => { 
        setChecked(!checked); //this doesn't actually happen until the method completes
        
        if(!checked) onSelectedHandler();
        else onDeselectedHandler();
***REMOVED***; 

    return (
        <>
            <div className="grid grid-cols-10 rounded-lg bg-stone-300 mb-1 mr-2">
                <div className="col-span-9">
                    {children}
                </div>
                <input type="checkbox" id="" defaultValue={false} className="mr-1" onChange={handleChange}/> 
            </div>
        </>
    );
}