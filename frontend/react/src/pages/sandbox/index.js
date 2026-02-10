import { useState } from "react"

export default function Sandbox() {
    return (
        <>
            <AddOrEditUser user={{age: 0, creditScore: 0}}/>
            <AddOrEditUser user={{id: 1, age: 46, creditScore: 4356}}/>
        </>
    )
}

export function NumberInput({binding, label, onChange}) {
    
    return (
        <>
        <label className="p-2">{label}</label>
        <input type="number" value={binding} onChange={(e) => onChange(e.target.value)} className="w-20"/>
        </>
    )
}


export function AddOrEditUser({user}) {

    if(!user) throw new Error("No user passed in")

    const buttonClass = "border border-blue-700 rounded bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4"
    const [userAge, setUserAge] = useState(user.age)
    const [userCreditScore, setUserCreditScore] = useState(user.creditScore)

    return (
        <>
            <h1 className="font-bold text-2xl">{(user.id) ? "Edit" : "Add"} user</h1>
            <div className="block flex gap-4 p-4">
                <NumberInput label="Age" binding={userAge} onChange={(e) => setUserAge(e)} />
                <NumberInput label="Credit score" binding={userCreditScore} onChange={(e) => setUserCreditScore(e)}/>
            </div>

            <button onClick={() => setUserCreditScore(95)} className={buttonClass} >
                Lookup credit score
            </button>
            
            <div className="block mb-6 p-4">
                <p>User age: {userAge}</p>
                <p>User credit score: {userCreditScore}</p>
            </div>
        </>
    )
}
