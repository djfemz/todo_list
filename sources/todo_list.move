
module todo_list::todo_list{
    use std::string::String;
    use std::string;
    #[test_only]
    use std::vector;
    #[test_only]
    use sui::object;
    #[test_only]
    use sui::tx_context;
    use rand::Rng;
    use rand;

    #[allow(unused_field)]
    public struct TodoList has key{
        id:UID,
        tasks:vector<String>
    }

    //add tasks to todo_list
    public fun add_task(list : &mut TodoList, task :String) : (String, bool){
         (string::utf8(b""), false)
    }
    // update tasks in todo_list


    #[test]
    public fun add_task_test(){
        let sender = @0x456;
        let mock_tx_hash = generate_mock_tx_hash();
        let current_epoch = system_state.epoch();
        let current_epoch_ms = tx_context::epoch_timestamp_ms(&mock_ctx);
        let ids_created:u64 = 12345;

        let mock_ctx = tx_context::new(sender, mock_tx_hash, current_epoch, current_epoch_ms, ids_created);

        let my_todo_list = TodoList{
            id:object::new(&mut mock_ctx),
            tasks: vector::empty()
        };

        let task = string::utf8(b"learn sui everyday");
        let (task_added, status) = add_task(&mut my_todo_list, task);
        assert!(task_added==task, 0);
        assert!(status==true, 0)
    }



    fun generate_mock_tx_hash() : vector<u8> {
        let mut rng = rand::thread_rng();
        let tx_hash_length = 32; // Assuming the length is 32 bytes
        (0..tx_hash_length).map(|_| rng.gen()).collect()
    }
}




