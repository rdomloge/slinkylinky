export default function TrafficLight(props) {
    return (
        <>
            <span className={"rounded-full m-1 p-2 inline-block text-white " +(props.value ? "bg-lime-600" : "bg-red-600")}>
                <p>{props.text}</p>
            </span>
        </>
    );
}