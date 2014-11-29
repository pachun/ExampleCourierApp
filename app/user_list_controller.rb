class UserListController < UIViewController
  def viewDidLoad
    super
    navigationItem.title = "People"
    view.backgroundColor = UIColor.whiteColor
    setup_filter_field
    setup_table_view
    fetch_all_users
  end

  def tableView(_, numberOfRowsInSection:_)
    @displayed_users.count
  end

  def tableView(_, cellForRowAtIndexPath:index_path)
    pos = index_path.row
    user = @displayed_users[pos]

    cell = recycled_cell || new_cell
    cell.textLabel.text = user.full_name
    cell
  end

  def tableView(_, didSelectRowAtIndexPath:index_path)
    @table_view.deselectRowAtIndexPath(index_path, animated:true)
    user = @displayed_users[index_path.row]
    post_list_controller = PostListController.alloc.initWithUser(user)
    navigationController.pushViewController(post_list_controller, animated:true)
  end

  def new_filter(notification)
    filter_text = notification.object.text
    if !filter_text.nil? && filter_text != ""
      scope = Courier::Scope.from_string("full_name contains #{filter_text}")
      @displayed_users = User.where(scope)
    else
      @displayed_users = User.all
    end
    @table_view.reloadData
  end

  private

  def fetch_all_users
    User.find_all do |response|
      if response[:response].success?

        # conflict_policy :overwrite_local" in user model auto-overwrites
        # local resources with foreign

        @displayed_users = User.all
        @table_view.reloadData
      else
        puts "error retreiving users: #{response[:error_message]}"
      end
    end
  end

  def setup_filter_field
    @filter_field = UITextField.alloc.initWithFrame([[20,70],[280,50]]).tap do |ff|
      ff.placeholder = "Filter By Name"
      ff.layer.borderWidth = 1
      ff.layer.borderColor = UIColor.blackColor.CGColor
      NSNotificationCenter.defaultCenter.addObserver(self,
                                                    selector: "new_filter:".to_sym,
                                                    name:UITextFieldTextDidChangeNotification,
                                                    object:ff)
      view.addSubview(ff)
    end
  end

  def setup_table_view
    @displayed_users = []
    @cell_reuse_id = "user cell"
    @table_view = UITableView.alloc.initWithFrame([[0,130],[320,220]], style:UITableViewStylePlain).tap do |tv|
      tv.layer.borderWidth = 1
      tv.layer.borderColor = UIColor.blackColor.CGColor
      tv.delegate = self
      tv.dataSource = self
      view.addSubview(tv)
    end
  end

  def recycled_cell
    @table_view.dequeueReusableCellWithIdentifier(@cell_reuse_id)
  end

  def new_cell
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cell_reuse_id)
  end
end
