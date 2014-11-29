class PostListController < UITableViewController
  def initWithUser(user)
    init.tap do
      @cell_reuse_id = "post cell"
      @user = user
    end
  end

  def viewDidLoad
    super
    navigationItem.title = "#{@user.full_name}'s Posts"
  end

  def viewWillAppear(animated)
    super(animated)
    refresh_posts
  end

  def tableView(_, numberOfRowsInSection:_)
    @user.posts.count
  end

  def tableView(_, cellForRowAtIndexPath:index_path)
    pos = index_path.row
    post = @user.posts[pos]

    cell = recycled_cell || new_cell
    cell.textLabel.text = post.title
    cell
  end

  def tableView(_, didSelectRowAtIndexPath:index_path)
    tableView.deselectRowAtIndexPath(index_path, animated:true)
    post = @user.posts[index_path.row]
    post_controller = PostController.alloc.initWithPost(post)
    navigationController.pushViewController(post_controller, animated: true)
  end

  private

  # don't overwrite any local posts
  def refresh_posts
    @user.find_posts do |posts|
      if posts[:response].success?
        posts[:conflicts].each do |conflict|
          conflict[:foreign].merge_if{ conflict[:local].nil? }
        end
        tableView.reloadData
      else
        puts "error retreiving posts: #{response[:error_message]}"
      end
    end
  end

  def recycled_cell
    tableView.dequeueReusableCellWithIdentifier(@cell_reuse_id)
  end

  def new_cell
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cell_reuse_id)
  end
end
