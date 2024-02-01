
import Image from "next/image";
import LockedImage from '@/components/locked.svg';


export default function TextInput({changeHandler, label, initialValue, stateValue, disabled, maxLen}) {

    const className = "appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"

    return (
        <div className="w-full px-3 mb-6 md:mb-0 border-b border-teal-500 mt-4">
            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2 align-middle" htmlFor="grid-name">
                {label}
                {disabled ?
                    <Image src={LockedImage} width={15} alt="Text input locked" className={"float-left"}/>
                : 
                    null
                }
            </label>
            {stateValue ?
                <input onChange={(e)=>changeHandler?changeHandler(e.target.value):{}} 
                    defaultValue={initialValue} 
                    value={stateValue} 
                    type="text" 
                    disabled={disabled}
                    className={className}
                    maxlength={maxLen ? maxLen : ""}/>
            :   
                <input onChange={(e)=>changeHandler?changeHandler(e.target.value):{}} 
                    defaultValue={initialValue} 
                    type="text" 
                    disabled={disabled}
                    className={className}
                    maxLength={maxLen ? maxLen : ""}/>
            }
            
        </div>
    );
}