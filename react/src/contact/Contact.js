import React from 'react';
import './Contact.css';
import PhoneContact from './PhoneContact';
import EmailContact from './EmailContact';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faUser } from '@fortawesome/free-solid-svg-icons'
import profilePic from './profile.png'

class Contact extends React.Component {
    render() {
        const contact = this.props;
        return (
            <div className="committee-member">
                <div className="shaded-area"/>
                <img src={profilePic} className="profile-pic"/>
                <div className="info">
                <div className="name">{contact.name}</div>    
                    <div className="role">{contact.role}</div>
                    {
                        contact.contactNumbers != null 
                        ? <div className="phone">{contact.contactNumbers.map(contact => <PhoneContact {...contact} key="{contact.type}"/>)}</div>
                        : <div/>
                    }
                    {
                        contact.email != null
                        ? <EmailContact{...contact}/>
                        : <div/>
                    }
                </div>
            </div>
        )
    }
}
  
export default Contact;