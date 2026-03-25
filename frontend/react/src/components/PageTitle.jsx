import '@/styles/globals.css'

export default function PageTitle(props) {
    if(!props.id) {
        throw new Error("Page title ID must be provided (for testing purposes)")
    }
    return (
        <div id={props.id} className="pageTitle inline-block">
            {props.title} {props.count ? " ("+props.count.length+")" : ""}
        </div>
    )
}