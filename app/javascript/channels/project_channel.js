import consumer from "./consumer";

const initProjectCable = () => {
  const tasksContainer = document.getElementById('tasks');
  if (tasksContainer) {
    const id = tasksContainer.dataset.projectId;
    const userId = tasksContainer.dataset.userId;

    consumer.subscriptions.create({ channel: "ProjectChannel", id: id }, {
      received(data) {
        const currentUserId = document.getElementById('mainContainer').dataset.userId
        const topicContainer = document.getElementById(`topic-${data.topic}`)
        const taskContainer = document.getElementById(`task-${data.id}`)


        // TASKS
        // TASK MADE PUBLIC
        if (data.create) {
          // const tokenTotalContainer = document.getElementById("tokenTotal")
          // tokenTotalContainer.innerHTML = parseInt(data.total)

          if (taskContainer === null) {
            tasksContainer.insertAdjacentHTML('afterbegin', data.partial);
            document.getElementById(`bubble-${data.id}`).classList.remove("d-none")
          } else {
            taskContainer.outerHTML = data.partial
          }

        // TASK EDITED
        } else if (data.update) {
          if (taskContainer) {
            // const tokenSubTotalContainer = document.getElementById("tokenSubTotal")
            // const tokenTotalContainer = document.getElementById("tokenTotal")
            // const tokenUserTotalContainer = document.getElementById("tokenUserTotal")

            taskContainer.parentElement.outerHTML = data.partial
            // tokenSubTotalContainer.innerHTML = parseInt(data.subtotal)
            // tokenTotalContainer.innerHTML = parseInt(data.total)

            // if (tokenUserTotalContainer.dataset.id == data.user_id) {
            //   tokenUserTotalContainer.innerHTML = parseInt(data.usertotal)
            // }
          }
        } else if (data.vote) {
          if (taskContainer && userId == data.current_user_id) {
            taskContainer.parentElement.outerHTML = data.partial
          } else if (taskContainer) {
            const tokenContainer = taskContainer.querySelector("#tokenContainer")
            
            if (tokenContainer) {
              tokenContainer.innerText = parseInt(tokenContainer.innerText) + 1
            }
          }
        }

        // TOPICS

        // if (!topicContainer && data.topic) {
        //   if ((data.private && data.current_user_id == currentUserId) || !data.private) {          
        //     const filtersContainer = document.getElementById("filtersContainer")
        //     filtersContainer.insertAdjacentHTML("beforeend", data.new_filter)
        //   }
        // }
        const bubble = document.getElementById(`bubble-${data.topic}`)
        if (bubble && !data.private && data.current_user_id !== parseInt(currentUserId)) {
          console.log("HAS THE BUBBLE")
          bubble.classList.remove("d-none")
        }
      },
    });
  }
}

export { initProjectCable };