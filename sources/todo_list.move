module todo_list::todo_list{
    use std::string;
    use std::string::String;
    use std::vector;
    #[test_only]
    use std::debug;
    #[test_only]
    use sui::object;
    #[test_only]
    use sui::test_scenario;
    #[test_only]
    use sui::transfer;


    #[allow(unused_field)]
    public struct TodoList has key{
        id:UID,
        tasks:vector<String>
    }

    // public fun new(ctx: &mut TxContext) :&mut TodoList{
    //     let todo_list = &mut TodoList{
    //         id: object::new(ctx),
    //         tasks: vector[]
    //     };
    //     debug::print(todo_list);
    //     todo_list
    // }

    //add tasks to todo_list
    public fun add_task(list : &mut TodoList, task :String) : (String, bool){
        list.tasks.push_back(task);
        let task_added = vector::borrow<String>(&list.tasks, list.tasks.length() - 1);
        (*task_added, true) // * --> used to dereference (obtain object) from reference
    }
    // TODO: implement remove_task feature of todo_list

    // TODO: implement mark_task_done feature of todo_list


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
        let (task_added, status) = my_todo_list.add_task(first_task);

        debug::print(&my_todo_list); // & --> used to obtain a reference to an object
        assert!(task_added==first_task, 0);
        assert!(status==true, 0);
        //4. transfer TodoList to my address.
        transfer::transfer(my_todo_list, mock_ctx.sender());

        //5. terminate test scenario
        test_scenario::end(scenario);
    }




}




