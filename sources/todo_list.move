module todo_list::todo_list{
    use std::string;
    use std::string::String;
    #[test_only]
    use std::debug;
    #[test_only]
    use sui::test_scenario;



    #[allow(unused_field)]
    public struct TodoList has key{
        id:UID,
        tasks:vector<Task>
    }

    public struct Task has key, store{
        id : UID,
        name: String,
        is_completed: bool
    }
    // public fun new(ctx: &mut TxContext) :&mut TodoList{
    //     let todo_list = &mut TodoList{
    //         id: object::new(ctx),
    //         tasks: vector[]
    //     };
    //     debug::print(todo_list);
    //     todo_list
    // }

    fun create_task(name:String, ctx:&mut TxContext):Task{
        let task = Task{
            id: object::new(ctx),
            name,
            is_completed:false

        };
        task
    }

    //add tasks to todo_list
    public fun add_task(list : &mut TodoList, task :String, ctx: &mut TxContext) : (&Task, bool){
        let new_task = create_task(task, ctx);
        list.tasks.push_back(new_task);
        let task_added = vector::borrow<Task>(&list.tasks, list.tasks.length() - 1);
        (task_added, true) // * --> used to dereference (obtain object) from reference
    }
    // TODO: implement remove_task feature of todo_list

    // TODO: implement mark_task_done feature of todo_list
    public fun mark_task_complete(list : &mut TodoList, id:UID): bool{
        let index:u64 =0;
        while(index < list.tasks.length()){
            let mut task = vector::borrow_mut<Task>(list.tasks, index);
            if(task.id == id){
                task.is_completed = true;
                return true
            }
        };
        false
    }

    fun update_task_status(task: Task, id:UID){

    }

    #[test]
    public fun add_task_test(){
        // 1. create test_scenario to obtain TxContext for UID of TodoList
        let sender_address = @0x123;
        let mut scenario = test_scenario::begin(sender_address);
        let mock_ctx = test_scenario::ctx(&mut scenario);

        // 2. instantiate TodoList
        let mut my_todo_list = TodoList{
            id:object::new(mock_ctx),
            tasks:vector[]
        };
        //3. add task to TodoList
        let first_task = string::utf8(b"start everyday with a dose of SUI");
        let (task_added, status) = my_todo_list.add_task(first_task, mock_ctx);

        debug::print(&my_todo_list); // & --> used to obtain a reference to an object
        assert!(task_added.name==first_task, 0);
        assert!(status==true, 0);
        //4. transfer TodoList to my address.
        transfer::transfer(my_todo_list, mock_ctx.sender());

        //5. terminate test scenario
        test_scenario::end(scenario);
    }

    #[test]
    public fun test_can_mark_task_done(){
        let sender_address = @0x123;
        let mut scenario = test_scenario::begin(sender_address);
        let mock_ctx = test_scenario::ctx(&mut scenario);
        // TODO: 1. create a todo_list
        let mut my_todo_list = TodoList{
            id:object::new(mock_ctx),
            tasks:vector[]
        };
        // TODO: 2. add tasks to todo_list
        let first_task = string::utf8(b"start everyday with a dose of SUI");
        let (first, _) = my_todo_list.add_task(first_task, mock_ctx);
        let second_task = string::utf8(b"task 2");
        let (second, _) = my_todo_list.add_task(second_task, mock_ctx);
        let third_task = string::utf8(b"task 3");
        let (third, _) = my_todo_list.add_task(third_task, mock_ctx);

        debug::print(&my_todo_list);
        // TODO: 3. mark a task as done
        let task_status = my_todo_list.mark_task_complete(first.id);
        // TODO: 4. check todo_list for task status
        assert!(task_status==true, 0);
        transfer::transfer(my_todo_list, mock_ctx.sender());
        test_scenario::end(scenario);
    }




}




