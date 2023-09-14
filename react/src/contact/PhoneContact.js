import React from 'react';
import './PhoneContact.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faMobilePhone } from '@fortawesome/free-solid-svg-icons'
import { faPhone } from '@fortawesome/free-solid-svg-icons'

class PhoneContact extends React.Component {
    render() {
        const contact = this.props;
        return (
            <div className="contact">
                <FontAwesomeIcon icon={contact.type==='Mobile'?faMobilePhone:faPhone} className="icon" />
                <div className="number">{contact.number}</div>
            </div>
        )
    }
}

export default PhoneContact;