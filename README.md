## Guardian360 App

Team Members

- [Tirthraj Mahajan](https://www.linkedin.com/in/tirthraj-mahajan/)
- [Amey Kulkarni](https://www.linkedin.com/in/amey-amit-kulkarni/)
- [Advait Joshi](https://www.linkedin.com/in/joshiadvait/)
- [Anshul Kalbande](https://www.linkedin.com/in/anshul-kalbande-a44b36219/)
- [Anurag Mandke](https://www.linkedin.com/in/anuragmandke/)

![Team Photo](public/team_photo.jpg)

---

## About

**Guardian360** is an emergency alert system developed for **[Techfiesta 2025](https://techfiesta.pict.edu/)**, a 24-hour hackathon organized by the **[Pune Institute of Computer Technology](https://www.pict.edu/)**. The project was undertaken as part of the **Women and Child Safety domain**, addressing the problem statement titled **Emergency Alert System**.

> **Problem Statement:**
> Create a system that would allow users to send a distress signal to predefined contacts, complete with their real-time location and a brief message. The solution needed to include a mobile app interface for sending alerts and a robust backend server to process and relay these alerts efficiently. It was a problem that demanded both technical precision and a deep understanding of the urgency and sensitivity of the situation.

The team behind Guardian360 comprises a group of passionate engineers with prior experience in hackathons and software development. In the previous year, the team participated in Techfiesta 2024, where they secured the 1st Runner-up position in the Healthcare category for their project, Local Shrinks. The experience gained from this prior endeavor played a significant role in shaping the team's approach to Guardian360. For more details on their previous work, refer to the project repository: [Local Shrinks](https://github.com/tirthraj07/Local-Shrinks).

Guardian360 was more than just a project for us; it was a mission to create something that could potentially save lives. Every line of code, every design decision, and every late-night debugging session was fueled by the belief that technology, when used thoughtfully, could make the world a safer place. And as the clock ticked down during those 24 hours, we poured our hearts into building a system that we hoped would one day make a real difference.

---

## Project Idea

After extensive brainstorming and deliberation, the team identified three critical phases to address in the context of emergency situations:

- **Precaution**
- **Panic**
- **Post-Incident**

Each phase was designed to cater to specific user needs, ensuring a comprehensive safety solution.

---

### Precaution Phase

The team firmly believes that "precaution is better than cure." This phase focuses on proactive measures to alert users about potential risks and ensure their safety before an incident occurs.

#### 1. Real-Time Location Sharing

Upon signing up, users can add trusted individuals to their **"Close Circle"**. Once configured, users can view the real-time location of their Close Circle members at all times. This feature operates seamlessly in both foreground and background modes.

To ensure accuracy and reliability, the team implemented a mechanism to bypass Android's restrictions, enabling location updates every **5-10 seconds**, even **when the device is switched off**. This is a significant improvement over existing applications, where location updates often experience delays of 30 seconds or more.

#### 2. Poking Mechanism

The Poking Mechanism is designed to verify the reachability of a user. By sending an `"Are you alive?"` signal to the recipient's device, the app automatically detects and responds to the request. This feature, also known as the **Heartbeat Mechanism**, ensures that users can quickly confirm the availability of their Close Circle members.

#### 3. Travel Alerts

For users traveling in taxis, buses, or other forms of transport where they may feel unsafe, the **Travel Mode** feature can be activated. This mode notifies the Close Circle about the cab number and sends frequent reminders to check on the user's location. Additionally, users can customize the frequency of these notifications based on their level of concern, ensuring timely updates during high-risk situations.

#### 4. Adaptive Location Alerts

To enhance situational awareness, the team implemented **Adaptive Location Alerts**. The city is divided into regions corresponding to police stations using a **Voronoi Diagram**. By leveraging geofencing, the app detects when a user enters a new region.

Upon entering a new region, the system evaluates aggregated incident reports based on their severity. If the severity score exceeds a predefined threshold, an Adaptive Location Alert is sent to the user. This alert provides details about recent incidents in the area, enabling users to exercise caution and make informed decisions about their safety.

This feature ensures that users are always aware of potential risks in their vicinity, empowering them to take proactive measures to stay safe.

---

### Panic Phase

---

### Post-Incident Phase

---

By addressing these three phases—Precaution, Panic, and Post-Incident—the team aimed to create a holistic safety solution that prioritizes user well-being and leverages technology to mitigate risks effectively.

---

## Project Implementation

### System Design

![System Design](public/Guardian360_System_Design.png)
