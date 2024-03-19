import React, {useState} from 'react'

export default function SelectableDemandCard({children, onSelectedHandler, onDeselectedHandler}) {
    const [checked, setChecked] = useState(false);

    const handleChange = () => { 
        setChecked(!checked); //this doesn't actually happen until the method completes
        
        if(!checked) onSelectedHandler();
        else onDeselectedHandler();
    }; 

    return (
        <>
            <div className="grid grid-cols-10 rounded-lg bg-stone-300 mb-1 mr-2">
                <div className="col-span-9">
                    {children}
                </div>
                <input type="checkbox" id="" defaultValue={false} className="mr-1 mt-4 rounded col-span-1 w-10 h-10 p-1" onChange={handleChange}/> 
            </div>
        </>
    );
}