
#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Formula SAE report",
  subtitle: "",
  subject: "Project report",
  guide: (
    name: "Stefano Chessa",
    designation: "Professor & Chair of the M.Sc. in Cybersecurity",
    department: "Computer Science"
  ),
  authors: (
    (
      name: "Daniele Giachetto", 
      department: "Department of Information Engineering",
      rollno: "647820"
    ),
    (
      name: "Edoardo Caciorgna",
      department: "Department of Information Engineering",
      rollno: "578245",
    ),
  ),
  department: "Department of Information Engineering",
  institute: "Università degli studi di Pisa",
  degree: "Master of Science",
  year: "2023-2024",
  logo: "images/logo-unipi.png",
)


= Introduction

Formula SAE is a student design competition, started in 1980 by the SAE student branch at the University of Texas at Austin after a prior asphalt racing competition proved to be unsustainable. The concept behind Formula SAE is that a fictional manufacturing company has contracted a student design team to develop a small Formula-style race car. Each student team designs, builds and tests a prototype based on a series of rules, whose purpose is both ensuring on-track safety and promoting clever problem solving. There are combustion and electric divisions of the competition, primarily only differing in their rules for powertrain.   
In 2017, the Formula Student Driverless was inaugurated, and in 2022 The Pisa Formula SAE's team started the transition to full electric and the development of the driverless software.

== Project goal

The goal of the project was to allow the Formula SAE team to pursue an increase in the security and reliability of the code base, mainly targeting the development, test and build phases of the software. The problem was not only technical, but one born from a culture of "if it works, it works." that led to the development of error prone and difficult to maintain software. 

= Documentation

The first task was the creation of a "code guide", aimed at guiding both new and experienced developers. The document follows a simple structure:
- General explanation and rules of the topic;
- Python specific rules and examples;
- C specific rules and examples.
The main topic tackled are:
- Project setup: How to correctly initialize a repository, the naming convention, how to enable CI, how to enable pre-commit;
- Project structure: Physical structure of the project, how the folders and file should be organized and what should be omitted;
- Documentation: How the code should be documented, what tools to use to generate documentation from comments;
- Testing: How to configure pre-commit, how to integrate static analysis tools and guidelines on how to write unit tests;
- Git branching strategy and Code reviews: What strategy should be used to create and manage branches and how to merge the developed code in the stable code base. 

= GitLab migration #label("GitLab migration")
A considerable challenge was encountered during the development of the documentation. The hosting service used to serve our code base to the developer (A hosted GitLab instance using Aruba), was in need of a renewal and for economic reasons the team decided to migrate to a free solution. This is a considerable challenge, even more if we need to consider the security aspect of the endeavour. The research was conducted on two possible solution:
1. Self host the GitLab instance;
2. Find a remote hosting service, possibly free.

An in-depth research on possible remote hosts for the team official site was also requested but, after having completed it, the team decided to scrap it in favour of simple (and insecure) WordPress hosting.

== Self hosted GitLab

Self hosting GitLab was problematic from the start.
- University firewall: the workshop's network is the same as the university one, and as such it has strict rules imposed on every computer. We tried asking the university for an exception to the rule, making the specific computer reachable on a specific port from outside the network but it was not granted;
- Secure the computer: there is only one computer at our disposal in the workshop. This means that we would need to have the computer accessible by everyone, but at the same time we need to guarantee the security and availability of the code stored in the machine;
- Guarantee instance availability: in specific times of the year, mainly when the other departments are rushing to meet specific deadlines, there are many power outages caused by the tools used. This issue could be solved using an uninterruptible power supply (UPS), that would kick in during power outages and guarantee a steady supply of power to the computer. The downside of this solution is cost, the entire computer setup is estimated to require from the power supply unit (PSU) ~1000W, meaning that a good UPS that could last for at least 15 minutes would cost at the very least 100€.

To summarize, the downside would be having to buy specific hardware and having a complex setup to avoid users accessing the code base from the shared computer in the workshop. On the upside, by having the service behind the University network, we could delegate a lot of security rules and architecture to the network. This option was abandoned in the end, because the university declined our request to make our service available and as such rendered impossible (or at the very least useless) the self host option.

== Remote hosting

There was a lot of talk regarding the direction in which we wanted to steer the code base hosting. The chosen service was GitHub, thanks to its perks like:
1. Ease of use: we have a lot of developers inexperienced with version control systems (VCS), and the easy to use GitHub graphic interface helps a lot;
2. Free tier: while we are aiming at a "team" license to have some needed extra security, we want to have the option in the future to swap easily from a paid version to a free version without having to migrate to a different service;
3. CI: GitHub offers free runners to execute the CI configuration that the developer desires;
There are obviously some cons, the majors being AI training with hosted code and the impossibility to protect branch on private repositories with a free account.

== Migration process

The final choice, taken by management after presenting all the pros and cons of each option, was to migrate to GitHub. There were 80 repositories to migrate, maintaining the commit history and, if possible, the issues.
To approach this challenge, a quick research was made to schedule a date in which no code would be committed to "freeze" the repositories. Code would stop being uploaded on the 25th of February 2024 and migration would take place on the 26th. GitHub offers a migration tool to import repositories keeping the commit history and also the authors as well. Knowing this, the decision was to import all the repositories manually using a profile token with only the minimum permissions required for the operation.
Another decision was dividing each repository between the teams, ETDV and Electronics, to have more modular access control and permissions. A new user that is not in a team will not be able to access any repository by default, while the user of one team will not be able to write on repositories of another team by default.
The process took around 8 hours, checking that each repository would correctly import everything and assigning them to the correct team. This process was also slowed down by various malfunction of the GitHub service, that would make the import fail. When an import fails it will still create a repository without any code inside of it, making it hard to retry (cannot import the same repository twice without deleting it first). 
On the morning of February 27th the process was completed successfully, only having to manually fix two repositories in the month after.

= CI/CD
CI/CD falls under DevOps (the joining of development and operations teams) and combines the practices of continuous integration and continuous delivery. CI/CD automates much or all of the manual human intervention traditionally needed to get new code from a commit into production, encompassing the build, test (including integration tests, unit tests, and regression tests), and deploy phases, as well as infrastructure provisioning. With a CI/CD pipeline, development teams can make changes to code that are then automatically tested and pushed out for delivery and deployment.
CI is the practice of integrating all your code changes into the main branch of a shared source code repository early and often, automatically testing each change when you commit or merge them, and automatically kicking off a build. With continuous integration, errors and security issues can be identified and fixed more easily, and much earlier in the development process. CD covers everything from provisioning the infrastructure to deploying the application to the testing or production environment.


== GitLab

To develop the CI/CD infrastructure the first step was to study how the GitLab runner works. This study was necessary to understand if we could work behind the University firewall or if we had to request again special permissions to the IT administrators.
#figure(
  image("images/GitLab_runner.png", width: 75%),
  caption: [GitLab pipeline]
)<gitlab_runners>
The process is often wrongly explained, saying that the GitLab server notifies each and every registered GitLab runner and then the runner starts the desired job. From our tests and some #link("https://forum.gitlab.com/t/how-does-communicate-gitlab-runners/7553/8")[forum discussions] we managed to understand the process:
- A GitLab runner is installed in the desired machine, either through Docker (recommended for #link("https://docs.gitlab.com/runner/security/")[security hardening]) or installing it directly in the system;
- The GitLab runner is registered though a guided process using a unique token;
- The GitLab runner starts to periodically poll the GitLab server for jobs;
- New code is pushed, the GitLab server checks if it triggers a job and then queues it;
- The GitLab runner fetches the job, it clones the project locally and then sends the results, logs, and status to the GitLab server.
This whole process does not require any inbound connection, the GitLab runner is responsible of contacting the GitLab server on port 443 (HTTPS). A bare bone CI/CD pipeline was developed and tested successfully but was scrapped because of the #link("GitLab migration")[migration to GitHub].

== GitHub

GitHub CI/CD approach is pretty different from GitLab. It offers free (up to a certain usage) online runners, and it also has a different convention for the configuration files. The old GitLab files were thus deleted and we approached this part of the migration process tailoring our solution specifically for GitHub.

=== GitHub-hosted runners
GitHub offers hosted virtual machines to run workflows. The virtual machine contains an environment of tools, packages, and settings available for GitHub Actions to use.
Each GitHub-hosted runner is a new virtual machine (VM) hosted by GitHub with the runner application and other tools preinstalled, and is available with Ubuntu Linux, Windows, or macOS operating systems. This is all leveraged automatically by activating the GitHub-hosted runners from the repository settings, no further configuration was required on our part.

=== GitHub Actions
The CI/CD configuration files, thanks to the _uses_ keyword, let us leverage the "GitHub Actions" functionality. An Action is a configuration written by other developers and freely shared on GitHub, allowing us to use CI/CD that is tested and supported by the community, minimizing the burden of maintaining the configuration. This marketplace helped us find ROS2 specific actions and examples to provide a better build process to our developers. 

Unfortunately, due to time constraints and the sheer amount of work in other projects, the CI/CD pipeline was not fully integrated. In the future we would like to integrate simulators to have complex test in which the whole stack could be tested at once in different tracks. To achieve that result we need to add a GitHub local runner with all the docker images installed (simulator, perception, etc) in the same system. This process cannot reasonably be done though remote runners since the whole stack is nearly 60GBs in size, and a remote runner needs to pull each dependency at every run of the CI/CD.


= Development Environment

#figure(
  image("images/ETDV-Deps.png", width: 75%),
  caption: [Dependencies graph]
)<Dependencies_graph>

The “Driverless” project builds are complicated to say the least. Every developer needs to install in its own machine all of the dependencies that the current project has, as shown in @Dependencies_graph. This led to builds error such as clashing libraries versions and in the production environment there were runtime dependencies missing. To solve this problem we had to create an environment containing all of the libraries required, so that it can be easily installed, replicated and in which development and builds can be done without issues.

#pagebreak()

== Inherited dockerfile analysis

We started the process by analyzing the old dockerfiles structure.

#figure(
  image("images/old_dockerfile.png", width: 75%),
  caption: [Old dockerfile list]
)<old_dockerfile_list>

The resulting docker image size was \~50GB, with compile times of hours at a time depending on the hardware resources and no clear instruction on the build process to follow.
Looking at all the dockerfiles we managed to track down where the issues originated:
- Build size: there was no clear distinction on the dockerfiles between build phases and final image, so libraries used to compile and build needed dependencies were kept on the final build image;
- Build time: the nvidia base image is the main issue in this regard. It needs to be compiled with regards to the target GPU architecture making a "generic" image useless;
- Instructions: there was some documentation in the README.MD, but knowledge was mainly shared vocally and held by very few people in the team.
== Dockerfile improvements
Initially moving to Virtual Machines was proposed and successfully tested. The rationale was that docker containers were already used as VMs and switching to them they could lead to true virtualized environment with all the needed tools and library already installed. Unfortunately this approach was not approved citing the increased hardware requirements.
To solve the problems listed previously, we adopted different strategies:
- Divided the dockerfiles in many cacheable images making the build more modular and with the possibility to resume it later on;
- Created a "minimal" version, that does not contain the perception layer, since not all the projects require it and saving tens of GB in the process;
- Deleted unused libraries and iteratively slim the images, checking for regressions at each step;

#figure(
  image("images/new_dockerfile_structure.png", width: 72%),
  caption: [New dockerfile list]
)<new_dockerfile_list>
== Docker infrastructure
With the goal of helping old PCs and low end hardware such as Raspberry PI, infamous for slow compile times, we decided to create a self hosted Docker Hub in which we would store all the versioned images.
In the future this choice would allow us to integrate those docker images in the CI/CD stages, to implement and execute tests in the same environment used by the developers.
#figure(
  image("images/new_dockerfile.png", width: 100%),
  caption: [Repository structure]
)<repository_structure>
To improve the user experience and avoid misalignment in each developer environment, a script that would guide the user in the creation of the images was created. The script exposes a Command Line Interface (CLI) that acts as a wizard for the image creation process. Following the goal of building scalable and modular software, this build process could also be used as base for the automatic creation of images at each major release, using the previously mentioned CI/CD pipeline.
#figure(
  image("images/build_helper.png", width: 100%),
  caption: [Image build wizard]
)<image_build_wizard>


= Personnel training

At the end of March, three new members joined the team earlier than usual in order to slowly train and adapt them to the projects. Firstly they got invited in the GitHub organization with minimum permissions to avoid confusion and mistakes. Then, shortly after, two main courses were held.
Both courses were recorded and slides created, in order to have them available even for future use in the next years.

The first lesson was on Git, touching all the following topics:
- Definition, use cases;
- Main commands like clone, add, commit, push, fetch, pull;
- GUI interfaces;
- Branches;
- Merge conflicts;
- Merge strategies.
- Our GitHub structure;
- Tour of the repositories.

The second lesson, much more in-depth, was on programming with a strong focus on safe programming:
- Difference between interpreted and compiled languages;
- Difference between Strong, weak, static and dynamic typing, with example of languages and code snippet for each one;
- Concept of scope;
- Concept of shadowing;
- Boolean algebra;
- Functions, signature and usage;
- Memory management;
- Garbage collection;
- Manual memory allocation and deallocation in C/C++;
- Pointers;
- Pointer arithmetic;
- Double free, use after free, dangling pointers, memory leaks;
- Basic rules to write memory safe code in C/C++;
- Rust and the borrow checker;
- Object oriented programming;
- What are objects and classes;
- Inheritance, Polymorphism, Abstraction, Encapsulation;
- Side effects, Shallow & Deep copies;
- How to avoid undesired side effects;


= Optimal lap trajectory #label("Optimal lap trajectory")

== The project

A new ETDV project, "ETDV optimal lap trajectory", was greenlighted with the goal of finding the optimal lap knowing the track beforehand. This is done by having the car drive as best as it can for the first lap, and then from the second lap onward the optimal lap trajectory will be used. The project will translate MATLAB code in a more efficient solution. This means that the result *must* be readily available at the beginning of the second lap and as such it has strict requirements in terms of:
- Small memory footprint;
- Memory safety;
- Reliability.

=== Memory footprint
Memory footprint refers to the amount of memory used by a program during its execution. Since the program will run in systems with very limited memory capabilities, the lower the memory consumption, the better. This requirement already excludes a lot of garbage collected languages, such as Java and Python.

=== Memory safety
To summarize a broad field of study, in our context memory safety means that all references point to valid memory. There are various programming languages that offer memory safety, mainly garbage collected ones. We care about memory safety for two reasons:
- Remove unexpected behaviours that could cause crashes like use after free;
- Security: bugs caused by lack of memory safety could range from simple crashes or, in the case of an attack, code injection.

=== Reliability
Software reliability is the probability of failure-free operation of a computer program for a specified period in a specified environment. This requirement is not as stringent as the others, because usually reliability issues appear in software after a long uptime. This last requirement is more related to good programming techniques than technologies or programming languages.

=== The choice of language
So, we need to find a programming language that offers the same safety guarantees of a garbage collected language together with the small memory footprint of manual memory management. Java, thanks to the JVM, is one of the fastest programming languages in the GC group while C/C++ are the de facto standard in the embedded programming scene. Even so, those languages lack at least one requirement each. Rust is the solution to all of these problems thanks to its runtime efficiency and borrow checker static analysis.



== Some theory
We can assume to know the *n* central point of the track, *p#sub[i]*.
Knowing that, we can calculate the coordinates of the points *r#sub[i]* thanks to the equation $ r#sub[i]= p#sub[i]+d#sub[i]*n#sub[i]$, where *n#sub[i]* is the unit normal vector to the tangent line at point *p#sub[i]*.

$ t = frac(x#sub[i+1] - x#sub[i], root(2, (x#sub[i+1]-x#sub[i])^2+(y#sub[i+1]-y#sub[i])^2)), frac(y#sub[i+1] - y#sub[i], root(2, (x#sub[i+1]-x#sub[i])^2+(y#sub[i+1]-y#sub[i])^2)) $

Considering the unit normal vector with regards to the plan $k = [0, 0, 1]$, $n#sub[i] = t * k$

To calculate the distance function to minimize:

$ sum_(i=1)^n (r#sub[i+1]-r#sub[i])^2 $

Now, we need an iterative process to minimize the distance function.

== Libraries
Since this is the first project ever made in the team with Rust, the choice of libraries was fundamental as it would pave the road and create an example to follow in future projects. 
#figure(
  image("images/libraries.png", width: 79%),
  caption: [Cargo.toml dependencies file]
)<libraries>


=== Nalgebra
Nalgebra is meant to be a general-purpose, low-dimensional, linear algebra library, with an optimized set of tools for computer graphics and physics.
Initially #link("")[ndarray], the de facto standard for linear algebra operations in machine learning, was chosen for the high performances offered but later on it was replaced by Nalgebra due to the slow release schedule and difficulty implementing with the ecosystem chosen. As seen with #link("https://github.com/rust-ndarray/ndarray/issues/794")[this issue], ndarray development is currently fragmented and the maintainers themselves #link("https://github.com/rust-ndarray/ndarray/issues/1272")[do not know what to do]. A good alternative that could be introduced in the future is #link("https://github.com/sarah-ek/faer-rs")[faer-rs], an open source linear algebra library that offers very high performances even with high dimensional matrices. \
Various benchmark can be found #link("https://github.com/sarah-ek/faer-rs?tab=readme-ov-file#benchmarks")[online], for our usage the speed critical operations are multiplication and inverse. The benchmark reported in this document compares the main three rust libraries with eigen, the c++ linear algebra library. At the time of writing, multiplication is mostly the same with ndarray being the fastest while faer-rs and nalgebra are similar. For the inverse operation we have ndarray still on top followed by faer-rs. All three libraries have valid speed, and as such only when dealing with optimization issues with high dimensional matrices Nalgebra should be swapped in favour of faer-rs. It's also worth noting that Rust libraries have similar or even better performances than the C++ library.

#figure(
  image("images/linear_algebra_comparison.PNG", width: 100%),
  caption: [Example of benchmarks between libraries]
)<linear_algebra_comparison>

=== Argmin
Argmin is a numerical optimization library written entirely in Rust.
Its goal is to offer a wide range of optimization algorithms with a consistent interface. It is type-agnostic by design, meaning that any type and/or math backend, such as Nalgebra or ndarray can be used – even your own.
An optional checkpointing mechanism helps to mitigate the negative effects of crashes in unstable computing environments.
Due to Rust's powerful generics and traits, most features can be exchanged by your own tailored implementations.
Argmin is designed to simplify the implementation of optimization algorithms and as such can also be used as a toolbox for the development of new algorithms. One can focus on the algorithm itself, while the handling of termination, parameter vectors, populations, gradients, Jacobians and Hessians is taken care of by the library.

=== Zenoh 
Zenoh is a pub/sub/query protocol unifying data in motion, data at rest and computations. It elegantly blends traditional pub/sub with geo distributed storage, queries and computations, while retaining a level of time and space efficiency that is well beyond any of the mainstream stacks.
All the software components of the ETDV suite communicate using network messages over tr the ROS2 infrastructure. ROS2 has some Rust support, mainly C wrappers, but the solution was not elegant and caused all the ROS2 problems to be introduced to the Rust technology stack. To justify choosing zenoh we need to understand the underlying mechanism of ROS2.
==== What is ROS2?
The Robot Operating System 2 (ROS2) is NOT an Operating System. It’s an open source robotics middleware, a set of software frameworks for software and robot development. This means that ROS2 offers us a set of tools to develop and make software communicate. ROS2 is used in the majority of the car projects, and has complete binding in Python, C, C++. We will use Rust, where the ROS2 ecosystem is still immature, and as such we need to find alternative ways to interface with the ROS2 communication schema.

==== How does ROS2 communicate?
ROS2 processes are represented as nodes in a graph structure, connected by edges called topics. ROS2 nodes can pass messages to one another through topics, make service calls to other nodes or provide a service for other nodes. ROS2 has a peer to peer structure with decentralized discovery mechanism, while ROS has a ROS master that is used to setup the connections between nodes.
#figure(
  image("images/ROS2_nodes_topic_service.gif", width: 100%),
  caption: [Nodes, topic and services in ROS2]
)<ROS2_nodes_topic_service>
- Nodes: A node represents one process running the ROS graph. Every node has a name, which it registers before it can take any other actions. Nodes are at the center of ROS programming, as most ROS client code is in the form of a ROS node which takes actions based on information received from other nodes, sends information to other nodes, or sends and receives requests for actions to and from other nodes;
- Topics: Topics are named buses over which nodes send and receive messages. To send messages to a topic, a node must publish to said topic, while to receive messages it must subscribe. The publish/subscribe model is anonymous: no node knows which nodes are sending or receiving on a topic, only that it is sending/receiving on that topic. The types of messages passed on a topic vary widely and can be user-defined. The content of these messages can be sensor data, motor control commands, state information, actuator commands, or anything else;
- Service: A node may also advertise services. A service represents an action that a node can take which will have a single result. As such, services are often used for actions which have a defined start and end, such as capturing a one-frame image, rather than processing velocity commands to a wheel motor or odometer data from a wheel encoder. Nodes advertise services and call services from one another.

==== Connect to ROS2 without using ROS2
ROS2 uses the Data Distributed Service (DDS) as its middleware and zenoh offers a bridge to communicate using DDS. What zenoh does is search for DDS readers and writers declared by ROS2 and after that is as simple as encoding messages using the same encoder as ROS2 and decoding them accordingly. Knowing this, we can setup zenoh to be able to communicating correctly with ROS2 nodes. More information can be found #link("https://zenoh.io/blog/2021-04-28-ros2-integration/")[in this official zenoh article]. It's worth noting that this technology stack will become more and more relevant as ROS2 development progresses because, at the end of 2023, the ROS2 community decided to officially move to zenoh as the next middleware. The decision can be found #link("https://discourse.ros.org/t/ros-2-alternative-middleware-report/33771")[here].

#pagebreak()

== Minimize the distance function

Function optimization is a foundational area of study and the techniques are used in almost every quantitative field. Importantly, function optimization is central to almost all machine learning algorithms, and predictive modeling projects. As such, it is critical to understand what function optimization is, the terminology used in the field, and the elements that constitute a function optimization problem. Function optimization is a subfielld of mathematics, and in modern times is addressed using numerical computing methods.

Function Optimization involves three elements: the input to the function (e.g. x), the objective function itself (e.g. f()) and the output from the function (e.g. cost).

- Input (x): The input to the function to be evaluated, e.g. a candidate solution;
- Function (f()): The objective function or target function that evaluates inputs;
- Cost: The result of evaluating a candidate solution with the objective function, minimized or maximized.

In our case, the function is converted from MATLAB to pure Rust and the argmin library offers lightweight abstraction that help us define and handle the input and cost. 

The best performing iterative algorithms usually present a gradient to help them calculate in which direction the minimum or maximum is, but in our case the gradient was not possible to calculate for computational complexity reason. For this reason we had to move to derivative-free constrained optimization.
The MATLAB code unfortunately did not delve in the algorithm to use, and simply used the provided fmincon function, that automatically chooses the most generic and often time inefficient algorithm. 

=== Cobyla
The name COBYLA is an acronym for Constrained Optimization by Linear Approximation. It is an iterative method for derivative-free constrained optimization. The method maintains and updates linear approximations to both the objective function and to each constraint. The approximations are based on objective and constraint values computed at the vertices of a well-formed simplex. Each iteration solves a linear programming problem inside a trust region whose radius decreases as the method progresses toward a constrained optimum. This algorithm is used in famous libraries like Scipy, and wrappers are found also for #link("https://github.com/relf/cobyla/")[Rust] with the main problem being that the underlying logic is written in Fortran and contains some pretty complicated bugs as highlighted by Dr. Zaikun Zhang in #link("https://github.com/relf/cobyla/issues/11")[this issue]. Nevertheless, it was the first approach tested mainly for the ease of use. There are still some problems, like an incompatibility with more recent argmin versions but overall it worked, finding valid solutions with low costs on low dimensional problems. The problems started to become impossible to solve with 200 dimensions, where COBYLA would struggle to converge.

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 1em,
        [ #image("images/cobyla50.jpg",   width: 100%) ],
        [ #image("images/cobyla200.jpg", width: 100%) ],
    ),
    caption: [COBYLA algorithm comparison between 50 and 200 dimensions]
) <cobyla_algorithm>

=== Particle Swarm

Particle swarm optimization (PSO) methods iteratively solve problems by moving a swarm of designs (“particles”) around the design space until convergence is reached. As these points move through the design space, they have some notion of velocity and momentum that govern how the designs vary iteration by iteration.

A real-world analogy is a swarm of mosquitoes moving in space trying to find a meal. They each individually exist in a point and as a group in a swarm, have some velocities, and are on the hunt for the best meal.

PSOs are metaheuristic and make few assumptions about the type of problem being solved. This is useful to explore the design space when you know nothing beforehand.

Testing this algorithm was fundamental to the introduction of parallel computation in the code base, that proved crucial in order to run the code faster with high dimensional matrices.

=== Simulated Annealing

Simulated Annealing (SA) is a stochastic optimization method which imitates annealing in metallurgy. Parameter vectors are randomly modified in each iteration, where the degree of modification depends on the current temperature. The algorithm starts with a high temperature (a lot of modification and hence movement in parameter space) and continuously cools down as  the iterations progress, hence narrowing down in the search. Under certain conditions, reannealing (increasing the temperature) can be performed. Solutions which are better than the previous one are always accepted and solutions which are worse are accepted with a probability proportional to the cost function value difference of previous to current parameter vector. These measures allow the algorithm to explore the parameter space in a large and a small scale and hence it is able to overcome local minima.

This was the algorithm that we decided to implement in the code base, easier to read and modify internally thanks to the Anneal functionality and also outperformed all the other algorithms in benchmarks with high dimensions (300).

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 0.3em,
        [ #image("images/cobyla.jpg",   width: 100%) ],
        [ #image("images/particle_swarm.jpg", width: 100%) ],
    ),
    caption: [Comparison between cobyla and particle swarm with 300 dimensions]
) <cobyla_particleswarm_comparison>

#figure(
  image("images/simulated_annealing.jpg", width: 60%),
  caption: [Simulated annealing with 300 dimensions]
)<simulated_annealing>

= Conclusions

== Achievement of the objectives
The main achievements of the experience were:
- Code base migration: completed successfully, with only a few GitLab issues lost in the process;
- Personnel training: completed successfully, with recording and slides available for the years to come;
- CI/CD pipeline: created the structure but did not implement much of the desired functionality;
- Lap optimization project: the code base is mature and working as desired, there are further improvements such as swapping the linear algebra library to increase matrix computational speed but these changes are not in priority.

== Knowledge gained
The #link("Optimal lap trajectory") project was personally the most interesting of the year. The original code was written in MATLAB as a proof of work, without any consideration for performances or reliability. In order to port in a more robust language, I had to work with an engineering student that knew almost nothing about programming and as such it led me to discover part of the project that were not explored. One such part was the simulated annealing algorithm that we had to implement and benchmark. Another project that made me understand the compromises that a cybersecurity expert must make, was the migration of the code base. No regards were given to the security and even enforcing the implementation of 2FA was not approved. As a cybersecurity student I think that I did my best with what I had. 

== Personal considerations
I consider the overall experience a positive one. Almost all the objectives set out at the start of the year have been completed and all the projects I've worked on have been developed with the goal of easily adding pieces or modifications. I think that I've also managed to raise awareness on many security related topics.
