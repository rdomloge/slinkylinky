import React from 'react';
import "./ClubSession.css"
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faMapMarkerAlt } from '@fortawesome/free-solid-svg-icons'
import { faClock } from '@fortawesome/free-solid-svg-icons'
import { faCalendar } from '@fortawesome/free-solid-svg-icons'
import { faHashtag } from '@fortawesome/free-solid-svg-icons'


class ClubSession extends React.Component {

    render() {
        const session = this.props;
        return (
            <div className="session">
                <div className="title">{session.title}</div>
                <div className="locationName">{session.locationName}</div>
                <div className="session-info flex-container">
                    <div className="flex-child-location location flex-container">
                        <div className="locationAddrIcon flex-icon">
                            <FontAwesomeIcon icon={faMapMarkerAlt} className="icon" />
                        </div>
                        <div className="locationAddr">
                            {session.locationAddr}
                        </div>
                    </div>
                    <div className="flex-child-details details">
                        <div className="start flex-container">
                            <FontAwesomeIcon icon={faClock} className="flex-child-details-icon icon" />
                            <div className="flex-child-details-text">{session.start}</div>
                        </div> 
                        <div className="days flex-container">
                            <FontAwesomeIcon icon={faCalendar} className="flex-child-details-icon icon" />
                            <div className="flex-child-details-text sidebyside">
                                {session.days}
                            </div>
                        </div>
                        <div className="numCourts flex-container">
                            <FontAwesomeIcon icon={faHashtag} className="icon" />
                            {session.numCourts} courts
                        </div>
                    </div>
                </div>
            </div>
        )
***REMOVED***
}

export default ClubSession