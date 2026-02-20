import 'package:flutter/material.dart';
import 'package:stms_app/app_theme.dart';

// ── Models ────────────────────────────────────────────────────────────────────
enum TaskStatus { pending, inProgress, completed, overdue }

class Task {
  final String id;
  final String title;
  final String course;
  final String courseCode;
  final DateTime dueDate;
  final TaskStatus status;
  final int priority; // 1=low, 2=medium, 3=high
  const Task({
    required this.id,
    required this.title,
    required this.course,
    required this.courseCode,
    required this.dueDate,
    required this.status,
    required this.priority,
  });
}

// ── Dashboard Screen ──────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TaskStatus _filterStatus = TaskStatus.pending;

  static final _tasks = [
    Task(
      id: '1',
      title: 'Data Structures Assignment 3',
      course: 'Data Structures & Algorithms',
      courseCode: 'CS301',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      status: TaskStatus.pending,
      priority: 3,
    ),
    Task(
      id: '2',
      title: 'Lab Report — Binary Trees',
      course: 'Data Structures & Algorithms',
      courseCode: 'CS301',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      status: TaskStatus.inProgress,
      priority: 2,
    ),
    Task(
      id: '3',
      title: 'UI/UX Design Mockups',
      course: 'Human Computer Interaction',
      courseCode: 'CS415',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: TaskStatus.inProgress,
      priority: 2,
    ),
    Task(
      id: '4',
      title: 'Database Normalisation Essay',
      course: 'Database Systems',
      courseCode: 'CS320',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      status: TaskStatus.overdue,
      priority: 3,
    ),
    Task(
      id: '5',
      title: 'Flutter Mobile App Project',
      course: 'Mobile App Development',
      courseCode: 'CS412',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: TaskStatus.inProgress,
      priority: 3,
    ),
    Task(
      id: '6',
      title: 'Research Paper Outline',
      course: 'Software Engineering',
      courseCode: 'CS401',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      status: TaskStatus.pending,
      priority: 1,
    ),
    Task(
      id: '7',
      title: 'Network Protocol Analysis',
      course: 'Computer Networks',
      courseCode: 'CS330',
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      status: TaskStatus.completed,
      priority: 2,
    ),
    Task(
      id: '8',
      title: 'Algorithm Complexity Quiz',
      course: 'Data Structures & Algorithms',
      courseCode: 'CS301',
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      status: TaskStatus.completed,
      priority: 1,
    ),
  ];

  List<Task> get _filteredTasks =>
      _tasks.where((t) => t.status == _filterStatus).toList();

  int get _total => _tasks.length;
  int get _completed =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get _overdue =>
      _tasks.where((t) => t.status == TaskStatus.overdue).length;
  int get _dueToday =>
      _tasks.where((t) {
        final d = t.dueDate;
        final n = DateTime.now();
        return d.year == n.year && d.month == n.month && d.day == n.day;
      }).length;

  double get _progress => _total == 0 ? 0 : _completed / _total;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 720;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(
        actions: [
          _NotificationBell(count: _overdue),
          const SizedBox(width: 8),
          _Avatar(),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.bg,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 32 : 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting ─────────────────────────────────────────────────
              _Greeting(),
              const SizedBox(height: 24),

              // ── Overall progress ─────────────────────────────────────────
              _ProgressBanner(
                completed: _completed,
                total: _total,
                progress: _progress,
              ),
              const SizedBox(height: 24),

              // ── Stats row ─────────────────────────────────────────────────
              const SectionLabel('OVERVIEW'),
              const SizedBox(height: 12),
              isWide
                  ? Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Total Tasks',
                          value: '$_total',
                          icon: Icons.assignment_rounded,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Completed',
                          value: '$_completed',
                          icon: Icons.task_alt_rounded,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Overdue',
                          value: '$_overdue',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Due Today',
                          value: '$_dueToday',
                          icon: Icons.today_rounded,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  )
                  : GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: [
                      _StatCard(
                        label: 'Total Tasks',
                        value: '$_total',
                        icon: Icons.assignment_rounded,
                        color: AppColors.blue,
                      ),
                      _StatCard(
                        label: 'Completed',
                        value: '$_completed',
                        icon: Icons.task_alt_rounded,
                        color: AppColors.green,
                      ),
                      _StatCard(
                        label: 'Overdue',
                        value: '$_overdue',
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.red,
                      ),
                      _StatCard(
                        label: 'Due Today',
                        value: '$_dueToday',
                        icon: Icons.today_rounded,
                        color: AppColors.gold,
                      ),
                    ],
                  ),
              const SizedBox(height: 28),

              // ── Upcoming deadline highlight ────────────────────────────
              _UpcomingBanner(tasks: _tasks),
              const SizedBox(height: 28),

              // ── Task list ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionLabel('MY TASKS'),
                  GestureDetector(
                    onTap: () => _showAddTaskSheet(context),
                    child: const Text(
                      '+ Add task',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter tabs
              _FilterTabs(
                selected: _filterStatus,
                onSelect: (s) => setState(() => _filterStatus = s),
                counts: {
                  TaskStatus.pending:
                      _tasks
                          .where((t) => t.status == TaskStatus.pending)
                          .length,
                  TaskStatus.inProgress:
                      _tasks
                          .where((t) => t.status == TaskStatus.inProgress)
                          .length,
                  TaskStatus.completed: _completed,
                  TaskStatus.overdue: _overdue,
                },
              ),
              const SizedBox(height: 12),

              // Task cards
              if (_filteredTasks.isEmpty)
                _EmptyState(status: _filterStatus)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _TaskCard(task: _filteredTasks[i]),
                ),
              const SizedBox(height: 80), // FAB clearance
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTaskSheet(),
    );
  }
}

// ── Top bar extras ─────────────────────────────────────────────────────────────
class _NotificationBell extends StatelessWidget {
  final int count;
  const _NotificationBell({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.notifications_rounded,
            color: AppColors.muted,
            size: 18,
          ),
        ),
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: AppColors.bg,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.gold.withOpacity(0.2),
            child: const Text(
              'SH',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.logout_rounded, color: AppColors.muted, size: 18),
        ],
      ),
    );
  }
}

// ── Greeting ──────────────────────────────────────────────────────────────────
class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = DateTime.now().hour;
    final greeting =
        h < 12
            ? 'Good morning'
            : h < 17
            ? 'Good afternoon'
            : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting ·',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 4),
        const Text(
          'Silas HAKUZWIMANA',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Computer Engineering · Year 3',
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

// ── Overall progress banner ───────────────────────────────────────────────────
class _ProgressBanner extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;
  const _ProgressBanner({
    required this.completed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withOpacity(0.15),
            AppColors.gold.withOpacity(0.04),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Semester Progress',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% complete',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completed of $total tasks completed',
            style: const TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          // Value + label stacked
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upcoming deadline highlight ───────────────────────────────────────────────
class _UpcomingBanner extends StatelessWidget {
  final List<Task> tasks;
  const _UpcomingBanner({required this.tasks});

  @override
  Widget build(BuildContext context) {
    final upcoming =
        tasks
            .where(
              (t) =>
                  t.status != TaskStatus.completed &&
                  t.dueDate.isAfter(DateTime.now()),
            )
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    if (upcoming.isEmpty) return const SizedBox.shrink();
    final next = upcoming.first;
    final diff = next.dueDate.difference(DateTime.now());
    final label =
        diff.inDays == 0
            ? 'Due today'
            : diff.inDays == 1
            ? 'Due tomorrow'
            : 'Due in ${diff.inDays} days';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.timer_rounded,
              color: AppColors.red,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  next.title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${next.courseCode}  ·  $label',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.red,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter tabs ───────────────────────────────────────────────────────────────
class _FilterTabs extends StatelessWidget {
  final TaskStatus selected;
  final ValueChanged<TaskStatus> onSelect;
  final Map<TaskStatus, int> counts;
  const _FilterTabs({
    required this.selected,
    required this.onSelect,
    required this.counts,
  });

  static const _tabs = [
    (TaskStatus.pending, 'Pending'),
    (TaskStatus.inProgress, 'In Progress'),
    (TaskStatus.overdue, 'Overdue'),
    (TaskStatus.completed, 'Done'),
  ];

  Color _tabColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending:
        return AppColors.gold;
      case TaskStatus.inProgress:
        return AppColors.blue;
      case TaskStatus.overdue:
        return AppColors.red;
      case TaskStatus.completed:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            _tabs.map((tab) {
              final isSelected = selected == tab.$1;
              final color = _tabColor(tab.$1);
              return GestureDetector(
                onTap: () => onSelect(tab.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? color.withOpacity(0.15) : AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? color.withOpacity(0.5)
                              : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        tab.$2,
                        style: TextStyle(
                          color: isSelected ? color : AppColors.muted,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? color.withOpacity(0.2)
                                  : AppColors.border,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${counts[tab.$1] ?? 0}',
                          style: TextStyle(
                            color: isSelected ? color : AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// ── Task card ─────────────────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final Task task;
  const _TaskCard({required this.task});

  Color get _statusColor {
    switch (task.status) {
      case TaskStatus.pending:
        return AppColors.gold;
      case TaskStatus.inProgress:
        return AppColors.blue;
      case TaskStatus.overdue:
        return AppColors.red;
      case TaskStatus.completed:
        return AppColors.green;
    }
  }

  String get _statusLabel {
    switch (task.status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.overdue:
        return 'Overdue';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get _priorityColor {
    switch (task.priority) {
      case 3:
        return AppColors.red;
      case 2:
        return AppColors.gold;
      default:
        return AppColors.muted;
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  String _formatDue(DateTime d) {
    final diff = d.difference(DateTime.now());
    if (task.status == TaskStatus.overdue) {
      return 'Overdue by ${(-diff.inDays)} day${(-diff.inDays) == 1 ? '' : 's'}';
    }
    if (diff.inDays == 0) return 'Due today';
    if (diff.inDays == 1) return 'Due tomorrow';
    return 'Due in ${diff.inDays} days';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              task.status == TaskStatus.overdue
                  ? AppColors.red.withOpacity(0.3)
                  : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Priority dot
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: _priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    color:
                        task.status == TaskStatus.completed
                            ? AppColors.muted
                            : AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration:
                        task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                    decorationColor: AppColors.muted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Status chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.school_outlined, size: 12, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(
                task.courseCode,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              const SizedBox(width: 12),
              Icon(Icons.schedule_outlined, size: 12, color: AppColors.muted),
              const SizedBox(width: 4),
              Text(
                _formatDue(task.dueDate),
                style: TextStyle(
                  color:
                      task.status == TaskStatus.overdue
                          ? AppColors.red
                          : AppColors.muted,
                  fontSize: 11,
                  fontWeight:
                      task.status == TaskStatus.overdue
                          ? FontWeight.w600
                          : FontWeight.normal,
                ),
              ),
              const Spacer(),
              Text(
                '$_priorityLabel priority',
                style: TextStyle(
                  color: _priorityColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final TaskStatus status;
  const _EmptyState({required this.status});

  @override
  Widget build(BuildContext context) {
    final isGood = status == TaskStatus.overdue;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            isGood ? Icons.check_circle_outline_rounded : Icons.inbox_rounded,
            size: 48,
            color: AppColors.muted.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            isGood ? 'No overdue tasks!' : 'No tasks here',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isGood) ...[
            const SizedBox(height: 4),
            const Text(
              'Great job staying on top of things.',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Add task bottom sheet ─────────────────────────────────────────────────────
class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _titleCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  int _priority = 2;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3));

  @override
  void dispose() {
    _titleCtrl.dispose();
    _courseCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (ctx, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(primary: AppColors.gold),
              dialogBackgroundColor: AppColors.card,
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Task',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.muted,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Title
          AppTextField(
            controller: _titleCtrl,
            label: 'Task title',
            icon: Icons.assignment_rounded,
          ),
          const SizedBox(height: 12),

          // Course
          AppTextField(
            controller: _courseCtrl,
            label: 'Course (e.g. CS301)',
            icon: Icons.school_rounded,
          ),
          const SizedBox(height: 16),

          // Priority selector
          const SectionLabel('PRIORITY'),
          const SizedBox(height: 8),
          Row(
            children: [
              _PriorityChip(
                label: 'Low',
                value: 1,
                selected: _priority,
                onTap: (v) => setState(() => _priority = v),
                color: AppColors.muted,
              ),
              const SizedBox(width: 8),
              _PriorityChip(
                label: 'Medium',
                value: 2,
                selected: _priority,
                onTap: (v) => setState(() => _priority = v),
                color: AppColors.gold,
              ),
              const SizedBox(width: 8),
              _PriorityChip(
                label: 'High',
                value: 3,
                selected: _priority,
                onTap: (v) => setState(() => _priority = v),
                color: AppColors.red,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Due date
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.muted,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Due: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                    style: const TextStyle(color: AppColors.text, fontSize: 13),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.muted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          AppButton(
            label: 'Add Task',
            onTap: () {
              // TODO: persist task via service layer
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task added successfully'),
                  backgroundColor: AppColors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final int value;
  final int selected;
  final ValueChanged<int> onTap;
  final Color color;
  const _PriorityChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color.withOpacity(0.5) : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppColors.muted,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
