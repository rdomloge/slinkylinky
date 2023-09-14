import React from 'react';
import './EmailContact.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEnvelope } from '@fortawesome/free-solid-svg-icons'

class EmailContact extends React.Component {
    render() {
        const contact = this.props;
        return (
            <div className="email">
                <FontAwesomeIcon icon={faEnvelope} className="icon" />
                <div className="email">{contact.email}</div>
            </div>
        )
    }
}

export default EmailContact;