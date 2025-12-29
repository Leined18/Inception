const projects = [
  { label: "📚 Libft", url: "https://github.com/Leined18/Libft", score: 125 },
  { label: "🖨️ ft_printf", url: "https://github.com/Leined18/ft_printf", score: 100 },
  { label: "📀 Born2beroot", url: null, score: 125 },
  { label: "📜 get_next_line", url: "https://github.com/Leined18/get_next_line", score: 112 },
  { label: "🎮 So_long", url: "https://github.com/Leined18/so_long", score: 125 },
  { label: "↹ Push_swap", url: "https://github.com/Leined18/Push_swap", score: 125 },
  { label: "🔗 Minitalk", url: "https://github.com/Leined18/Minitalk", score: 125 },
  { label: "🍴 Philosophers", url: "https://github.com/Leined18/Philosophers", score: 100 },
  { label: "🐚 Minishell", url: "https://github.com/Leined18/minishell", score: 125 },
  { label: "🤖 CPP Modules 00-04", url: null, score: null, subprojects: [
    { label: "CPP 00", url: "https://github.com/Leined18/cpp-module-00", score: 100 },
    { label: "CPP 01", url: "https://github.com/Leined18/cpp-module-01", score: 100 },
    { label: "CPP 02", url: "https://github.com/Leined18/cpp-module-02", score: 100 },
    { label: "CPP 03", url: "https://github.com/Leined18/cpp-module-03", score: 100 },
    { label: "CPP 04", url: "https://github.com/Leined18/cpp-module-04", score: 100 }
  ]},
  { label: "🖧 NetPractice", url: "https://github.com/Leined18/Netpractice", score: 100 },
  { label: "🔦 Cube3D", url: "https://github.com/Leined18/Cube3D", score: 125 },
  { label: "🌐 Webserv", url: null, score: 0 },
  { label: "🤖 CPP Modules 05-09", url: null, score: 0, subprojects: [
    { label: "CPP 05", url: "https://github.com/Leined18/cpp-module-05", score: 100 },
    { label: "CPP 06", url: "https://github.com/Leined18/cpp-module-06", score: 100 },
    { label: "CPP 07", url: "https://github.com/Leined18/cpp-module-07", score: 0 },
    { label: "CPP 08", url: "https://github.com/Leined18/cpp-module-08", score: 0 },
    { label: "CPP 09", url: "https://github.com/Leined18/cpp-module-09", score: 0 }
  ]},
  { label: "Inception", url: null, score: 0 }
];

function createProjectButton(project) {
  const btn = document.createElement('a');
  btn.className = 'project-btn';
  btn.textContent = `${project.label}${project.score ? ` (${project.score}%)` : ''}`;
  if (project.url) {
    btn.href = project.url;
    btn.target = '_blank';
  } else {
    btn.classList.add('disabled');
    btn.href = '#';
  }
  return btn;
}

function renderProjects(list, container) {
  list.forEach(project => {
    const wrapper = document.createElement('div');
    wrapper.className = 'project-item';
    // Solo usar menú desplegable si tiene subproyectos
    if (project.subprojects) {
      const dropdown = document.createElement('div');
      dropdown.className = 'dropdown';
      const btn = createProjectButton(project);
      btn.classList.add('dropdown-btn');
      dropdown.appendChild(btn);
      const sublist = document.createElement('div');
      sublist.className = 'dropdown-content';
      renderProjects(project.subprojects, sublist);
      dropdown.appendChild(sublist);
      wrapper.appendChild(dropdown);
    } else {
      wrapper.appendChild(createProjectButton(project));
    }
    container.appendChild(wrapper);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('projects-list');
  renderProjects(projects, container);
});
