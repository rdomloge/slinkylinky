

export default function TrafficLight(props) {

    return (
        <>
            <span className={"rounded-full m-1 p-2 inline-block border-2 " +(props.value ? "bg-lime-600 text-white border-solid" : "border-dashed border-slate-400")}>
                <p>{props.text}</p>
            </span>
        </>
    );
}