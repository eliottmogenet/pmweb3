import consumer from "./consumer";

const initProjectCable = () => {
  const tasksContainer = document.getElementById('tasks');
  if (tasksContainer) {
    const id = tasksContainer.dataset.projectId;

    consumer.subscriptions.create({ channel: "ProjectChannel", id: id }, {
      received(data) {
        const topicContainer = document.getElementById(`topic-${data.topic}`)
        const taskContainer = document.getElementById(`task-${data.id}`)

        if (data.create) {
          const tokenTotalContainer = document.getElementById("tokenTotal")
          tokenTotalContainer.innerHTML = parseInt(data.total)

          if (taskContainer === null) {
            tasksContainer.insertAdjacentHTML('afterbegin', data.partial);
          } else {
            taskContainer.outerHTML = data.partial
          }

          if (!topicContainer && data.topic) {
            const filtersContainer = document.getElementById("filtersContainer")
            filtersContainer.insertAdjacentHTML("beforeend", data.new_filter)
          }

          const bubble = document.getElementById(`bubble-${data.topic}`)
          if (bubble) {
            bubble.classList.remove("d-none")
          }
        } else if (data.update) {
          if (taskContainer && !topicContainer) {
            const tokenSubTotalContainer = document.getElementById("tokenSubTotal")
            const tokenTotalContainer = document.getElementById("tokenTotal")
            const tokenUserTotalContainer = document.getElementById("tokenUserTotal")

            taskContainer.parentElement.outerHTML = data.partial
            tokenSubTotalContainer.innerHTML = parseInt(data.subtotal)
            tokenTotalContainer.innerHTML = parseInt(data.total)

            if (tokenUserTotalContainer.dataset.id == data.user_id) {
              tokenUserTotalContainer.innerHTML = parseInt(data.usertotal)
            }

            if (!data.mark_as_done) {            
              const filtersContainer = document.getElementById("filtersContainer")
              filtersContainer.insertAdjacentHTML("beforeend", data.new_filter)
            }
          } 
          if (taskContainer && topicContainer) {
            const tokenSubTotalContainer = document.getElementById("tokenSubTotal")
            const tokenTotalContainer = document.getElementById("tokenTotal")
            const tokenUserTotalContainer = document.getElementById("tokenUserTotal")

            taskContainer.parentElement.outerHTML = data.partial
            tokenSubTotalContainer.innerHTML = parseInt(data.subtotal)
            tokenTotalContainer.innerHTML = parseInt(data.total)

            if (tokenUserTotalContainer.dataset.id == data.user_id) {
              tokenUserTotalContainer.innerHTML = parseInt(data.usertotal)
            }
            const bubble = document.getElementById(`bubble-${data.topic}`)
            if (bubble) {
              bubble.classList.remove("d-none")
            }

          } else {
            console.log("Not there")
          }
        }
      },
    });
  }
}

export { initProjectCable };