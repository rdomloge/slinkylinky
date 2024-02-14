
import Image from "next/image";
import LockedImage from '@/components/locked.svg';


export default function TextInput({changeHandler, label, binding, disabled, maxLen, id}) {

    const className = "appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"

    return (
        <div className="w-full px-3 mb-6 md:mb-0 border-b border-teal-500 mt-4">
            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2 align-middle" htmlFor="grid-name">
                {label}
                {disabled ?
                    <Image src={LockedImage} width={15} alt="Text input locked" className={"float-left"}/>
                : 
                    null
            ***REMOVED***
            </label>
            <input onChange={(e)=>changeHandler(e.target.value)} 
                    value={binding} 
                    type="text" 
                    disabled={disabled}
                    className={className}
                    maxLength={maxLen ? maxLen : ""}
                    id={id}/>
            
        </div>
    );
}