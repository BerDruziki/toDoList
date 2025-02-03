require 'pg'

class TodoList
  def initialize
    # Conectando ao banco de dados PostgreSQL
    @conn = PG.connect(dbname: 'seu_banco', user: 'seu_usuario', password: 'sua_senha')
  end

  def show_menu
    puts "\n--- Lista de Tarefas ---"
    puts "1. Adicionar tarefa"
    puts "2. Remover tarefa"
    puts "3. Listar tarefas"
    puts "4. Marcar tarefa como concluída"
    puts "5. Sair"
    print "Escolha uma opção (1-5): "
  end

  def add_task(description)
    query = "INSERT INTO tasks (description, completed) VALUES ($1, $2)"
    @conn.exec_params(query, [description, false])
    puts "Tarefa '#{description}' adicionada!"
  end

  def remove_task(id)
    query = "DELETE FROM tasks WHERE id = $1"
    @conn.exec_params(query, [id])
    puts "Tarefa com ID #{id} removida!"
  end

  def list_tasks
    result = @conn.exec("SELECT * FROM tasks")
    if result.ntuples == 0
      puts "Nenhuma tarefa encontrada."
    else
      puts "\nTarefas:"
      result.each_with_index do |task, index|
        status = task['completed'] == 't' ? "Concluída" : "Pendente"
        puts "#{task['id']}. #{task['description']} - #{status}"
      end
    end
  end

  def mark_task_completed(id)
    query = "UPDATE tasks SET completed = TRUE WHERE id = $1"
    @conn.exec_params(query, [id])
    puts "Tarefa com ID #{id} marcada como concluída!"
  end

  def close_connection
    @conn.close
  end
end

# Função principal que roda o sistema de tarefas
def main
  todo_list = TodoList.new

  loop do
    todo_list.show_menu
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Digite a descrição da tarefa: "
      task = gets.chomp
      todo_list.add_task(task)
    when 2
      todo_list.list_tasks
      print "Digite o ID da tarefa a ser removida: "
      task_id = gets.chomp.to_i
      todo_list.remove_task(task_id)
    when 3
      todo_list.list_tasks
    when 4
      todo_list.list_tasks
      print "Digite o ID da tarefa a ser marcada como concluída: "
      task_id = gets.chomp.to_i
      todo_list.mark_task_completed(task_id)
    when 5
      puts "Saindo..."
      break
    else
      puts "Opção inválida, tente novamente."
    end
  end

  # Fechar a conexão com o banco ao sair
  todo_list.close_connection
end

# Executando o programa
main


# source 'https://rubygems.org'
# gem 'pg'

# bundle install