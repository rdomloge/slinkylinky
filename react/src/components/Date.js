export default function NiceDate(props) {
    return (
        <>
            <p>{new Date(props.isostring).toDateString()}</p>
        </>
    );
}